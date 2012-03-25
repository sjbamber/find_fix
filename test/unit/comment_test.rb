require 'test_helper'

class CommentTest < ActiveSupport::TestCase
# Load Test data
fixtures :comments
  # setup objects for tests
  def setup
    @comment = Comment.new
  end

  # Test Validation Works
  test "comment name must not be empty" do
    assert @comment.invalid?
    assert @comment.errors[:comment].any?, "comment must be present"
  end

  test "comment must not be over 255 characters" do 
    @comment.comment = "a"*256
    assert @comment.invalid?, "comment over 255 characters should not be valid"
    @comment.comment = "a"*255
    assert @comment.valid?, "comment under 255 characters should be valid"   
  end
end
