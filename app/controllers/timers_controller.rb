require_relative '../workers/timer_worker'

class TimersController < ApplicationController

	def post
		id = params[:id]
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
end
