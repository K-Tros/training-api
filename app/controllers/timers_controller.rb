require_relative '../workers/timer_worker'

class TimersController < ApplicationController
	# Probably not good practice since this gets done before all actions, but doing it here
	# just to see how it works
	before_action :require_post_params

	def post
		# validate the actual content
		id = params[:id]
		puts params
		if id.length != 15 || id[/\H/]
			render json: {status: 'FAILED', message: 'Invalid ID value'}, status: :bad_request
		else
			# if new:
			if !Timer.exists?(identifier: id)
				puts "New ID: Creating new timer."
				timer = Timer.new(identifier: id)
				# start new "timer" job
				jid = TimerWorker.perform_async
				timer.jid = jid
				timer.save
			else
			# if not new
				timer = Timer.find_by(identifier: id)
				if timer.jid
					puts "Existing ID: Killing timer."
				  TimerWorker.cancel!(timer.jid)
				  timer.update(jid: nil)
				else
					puts "Existing ID: Starting new instance timer."
					jid = TimerWorker.perform_async
					timer.update(jid: jid)
				end
			end
			render json: {status: 'SUCCESS', message: 'POST succeeded'}, status: :ok
		end
	end

	private
	def require_post_params
		puts params
		params.require(:id)
		params = params.slice('id', 'payload')
	end
end
