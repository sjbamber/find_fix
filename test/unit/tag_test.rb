require 'test_helper'

class TagTest < ActiveSupport::TestCase
# Load Test data
fixtures :tags  

# Test Validation Works
  test "tag name must not be empty" do
    tag = Tag.new
    assert tag.invalid?
    assert tag.errors[:name].any?, "Tag name must be present"
  end

  test "tag name is between 3 and 100 characters" do
    tag = Tag.new
    
    tag.name = "a"*101
    assert tag.invalid?, "Tag name over 100 characters should not be valid"

    tag.name = "a"*2
    assert tag.invalid?, "Tag name under 3 characters should not be valid"    

    tag.name = "a"*100
    assert tag.valid?, "Tag name of between 3 and 100 characters should be valid" 
    
    tag.name = "a"*3
    assert tag.valid?, "Tag name of between 3 and 100 characters should be valid" 
  end
  
end
