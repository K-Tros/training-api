require 'test_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class TimersControllerTest < ActionDispatch::IntegrationTest
	def setup
		DatabaseCleaner.start
		@valid_identifier = '1234567890abcde'
	end

	test "valid params" do
		DatabaseCleaner.clean
		post "/api/v1/timers", params: { id: @valid_identifier }
		assert_response :success
	  # check that the ID was entered in the DB
		timer = Timer.find_by(identifier: @valid_identifier)
		refute_nil timer
		# and that it was assigned a JID for the background timer
		refute_nil timer.jid
		# make sure that a timer job would have been started
		assert_equal 1, TimerWorker.jobs.size

		# call API again and make sure JID is nil signifying the job was canceled
		post "/api/v1/timers", params: { id: @valid_identifier }
		assert_response :success
		timer = Timer.find_by(identifier: @valid_identifier)
		refute_nil timer
		assert_nil timer.jid

		# start the timer again and confirm that it restarted the timer
		post "/api/v1/timers", params: { id: @valid_identifier }
		assert_response :success
		timer = Timer.find_by(identifier: @valid_identifier)
		refute_nil timer
		refute_nil timer.jid
		# make sure that a timer job would have been started
		assert_equal 2, TimerWorker.jobs.size

		# ensure that it did not create multiple records in the database
		assert_equal 1, Timer.where(identifier: @valid_identifier).count
	end

	test "invalid without identifier" do
		assert_raises ActionController::ParameterMissing do
			post "/api/v1/timers", params: { }
		end
	end

	test "invalid with bad non-hex identifier" do
		DatabaseCleaner.clean
		post "/api/v1/timers", params: { id: 'mkmkmkmkmkmkmkk' }
		assert_response :bad_request
	end
end