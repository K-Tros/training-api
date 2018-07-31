class TimerWorker
  include Sidekiq::Worker
  # KRT: expire only works in sidekiq pro?
  # sidekiq_options expires_in: 1.minute

  def perform(*args)
    # start a "timer" and run it until whenever
    start_time = Time.now.to_i

    expiration_time = Config.find_by(description: 'Timer expiration').value.to_f
    
    # just run forever (i.e. until expired or cancelled)
    while !cancelled? && (Time.now.to_f - start_time) < expiration_time
    end

    # remove own JID from Timer table
    timer = Timer.find_by(jid: jid)
    # Don't try this update if a Timer with this JID does not exist
    if timer
      timer.update(jid: nil)
    end

    end_time = Time.now.to_f

    puts "Timer JID:#{jid} ran for: #{end_time - start_time} seconds"
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
