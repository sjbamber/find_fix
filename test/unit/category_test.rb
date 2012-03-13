require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
# Load Test data
fixtures :categories
  # setup objects for tests
  def setup
    @category = Category.new
  end

  # Test Validation Works
  test "category name must not be empty" do
    assert @category.invalid?
    assert @category.errors[:name].any?, "Category name must be present"
  end

  test "category name is between 3 and 255 characters" do
    
    @category.name = "a"*256
    assert @category.invalid?, "Category name over 255 characters should not be valid"

    @category.name = "a"*2
    assert @category.invalid?, "Category name under 3 characters should not be valid"    

    @category.name = "a"*255
    assert @category.valid?, "Category name of between 3 and 255 characters should be valid" 
    
    @category.name = "a"*3
    assert @category.valid?, "Category name of between 3 and 255 characters should be valid" 
  end
  
  test "category name must not already exist" do
    @category.name = "Windows"
    assert @category.invalid?, "Category Should not already exist"
  end
  
end
