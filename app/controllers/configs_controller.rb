class ConfigsController < ApplicationController
	# Probably not good practice since this gets done before all actions, but doing it here
	# just to see how it works
	before_action :set_params

	# takes config description and value pair, inserts or updates the configs table for the given value
  def set
  	description = params[:description]
  	value = params[:value]

  	config = Config.find_or_initialize_by(description: description)
  	config.update(value: value)
  	render json: {status: 'SUCCESS', message: 'Updated config'}, status: :ok
  end

  private
	def set_params
		params.require(:description)
		params.require(:value)
		params.permit(:description, :value)
	end
end
