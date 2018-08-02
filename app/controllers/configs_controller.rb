class ConfigsController < ApplicationController
	# takes config description and value pair, inserts or updates the configs table for the given value
  def set
  	description = set_params[:description]
  	value = set_params[:value]

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
