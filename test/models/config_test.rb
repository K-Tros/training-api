require 'test_helper'
 
class ConfigTest < ActiveSupport::TestCase
	def setup
		@config = configs(:valid)
	end

  test "valid config" do
  	assert @config.valid?
  end

  test "invalid without description" do
  	config.description = nil
  	refute @config.valid?
  	assert_not_nil config.errors[:description]
  end

  test "should not allow duplicate descriptions" do
  	config1 = Config.new
  	config1.description = @config.description
  	refute config1.valid?
  end
end