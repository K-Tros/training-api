require_relative '../workers/timer_worker'

class TimersController < ApplicationController
	# Probably not good practice since this gets done before all actions, but doing it here
	# just to see how it works
	before_action :post_params

	def post
		# validate the actual content
		id = params[:id]
		timer = Timer.new(identifier: id)
		# if new:
		if !Timer.exists?(identifier: id)
			if timer.invalid?
				render json: {status: 'FAILED', message: 'Invalid ID value'}, status: :bad_request
			else
				puts "New ID: Creating new timer."
				jid = TimerWorker.perform_async
				timer.jid = jid
				timer.save
				render json: {status: 'SUCCESS', message: 'POST succeeded'}, status: :ok
			end
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
			render json: {status: 'SUCCESS', message: 'POST succeeded'}, status: :ok
		end
	end

	private
	def post_params
		params.require(:id)
		params.permit(:id, :payload)
	end
end
