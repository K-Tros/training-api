require 'test_helper'
 
class TimerTest < ActiveSupport::TestCase
  def setup
		@timer = timers(:valid)
	end

  test "valid timer" do
  	assert @timer.valid?
  end

  test "invalid with ID length not equal to 15" do
  	@timer.identifier = 'abcdefghiklmno' # 14 characters long
  	refute @timer.valid?
  	@timer.identifier = 'abcdefghiklmnopq' # 16 characters long
  	refute @timer.valid?
  end

  test "invalid without identifier" do
  	@timer.identifier = nil
  	refute @timer.valid?
  	assert_not_nil @timer.errors[:identifier]
  end

  test "should not allow duplicate identifiers" do
  	timer1 = Timer.new
  	timer1.identifier = @timer.identifier
  	refute timer1.valid?
  end
end