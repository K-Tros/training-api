require 'test_helper'
 
class ConfigTest < ActiveSupport::TestCase
  test "valid config" do
  	config = Config.new(description: 'test', value: 'test_value')
  	assert config.valid?
  end

  test "invalid without description" do
  	config = Config.new(value: 'test_value')
  	refute config.valid?
  	assert_not_nil config.errors[:description]
  end

  test "should not allow duplicate descriptions" do
  	config1 = Config.new
  	config1.description = 'test'
  	config1.save
  	config2 = Config.new
  	config2.description = 'test'
  	refute config2.valid?
  end
end