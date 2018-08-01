class ConfigsController < ApplicationController
	# takes config description and value pair, inserts or updates the configs table for the given value
  def set
  	description = params[:description]
  	value = params[:value]

  	if !(description && value)
  		render json: {status: 'FAILED', message: 'Invalid Arguments'}, status: :bad_request
  	else
  		config = Config.find_or_initialize_by(description: description)
  		config.update(value: value)
  		render json: {status: 'SUCCESS', message: 'Updated config'}, status: :ok
  	end
  end
end
