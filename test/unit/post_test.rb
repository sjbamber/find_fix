require 'test_helper'

class PostTest < ActiveSupport::TestCase
# Load Test data
fixtures :posts, :tags, :categories
  # setup objects for tests
  def setup
    @post = Post.new
    @category = Category.find_by_name("Windows")
    @tag = Tag.find_by_name("Windows XP")
  end

  # Test Validation Works
  test "post attributes must not be empty" do
    assert @post.invalid?
    assert @post.errors[:title].any?, "Post title must be present"
    assert @post.errors[:description].any?, "Post description must be present"
    assert @post.errors[:categories].any?, "At least one post category must be present"
    assert @post.errors[:tags].any?, "At least one post tag must be present"
  end

  test "post title is a maximum of 255 characters" do
    @post.description = "test"
    @post.categories << @category
    @post.tags << @tag
    
    @post.title = "a"*256
    assert @post.invalid?, "Post title over 255 characters should not be valid"

    @post.title = "a"*255
    assert @post.valid?, "Post title of 255 characters and under should be valid" 
  end
end
