require 'test_helper'

class ErrorMessageTest < ActiveSupport::TestCase
# Load Test data
fixtures :error_messages
  # setup objects for tests
  def setup
    @error_message = ErrorMessage.new
  end

# Test Validation Works
  test "error message description must not be empty" do
    assert @error_message.invalid?
    assert @error_message.errors[:description].any?, "ErrorMessage description must be present"
  end

  test "error message description is between 3 and 255 characters" do
    
    @error_message.description = "a"*256
    assert @error_message.invalid?, "ErrorMessage description over 255 characters should not be valid"

    @error_message.description = "a"*2
    assert @error_message.invalid?, "ErrorMessage description under 3 characters should not be valid"    

    @error_message.description = "a"*255
    assert @error_message.valid?, "ErrorMessage description of between 3 and 255 characters should be valid" 
    
    @error_message.description = "a"*3
    assert @error_message.valid?, "ErrorMessage description of between 3 and 255 characters should be valid" 
  end
  
end
