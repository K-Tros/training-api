require 'test_helper'

class ConfigControllerTest < ActionDispatch::IntegrationTest

	test "valid params" do
		post "/api/v1/configs", params: { description: 'test', value: '10' }
		assert_response :success
		# check that the commit succeeded
		assert_equal '10', Config.find_by(description: 'test').value
		# change the value and check that the change happened
		post "/api/v1/configs", params: { description: 'test', value: '20' }
		assert_response :success
		assert_equal '20', Config.find_by(description: 'test').value
	end

	test "invalid without description" do
		assert_raises ActionController::ParameterMissing do
			post "/api/v1/configs", params: { value: '10' }
		end
	end

	test "invalid without value" do
		assert_raises ActionController::ParameterMissing do
			post "/api/v1/configs", params: { description: 'test' }
		end
	end
end