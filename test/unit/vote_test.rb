require 'test_helper'

class VoteTest < ActiveSupport::TestCase
# Load Test data
fixtures :vote_types, :users, :posts, :comments 
  # setup objects for tests
  def setup
    @user = users(:alice)
    @vote_type = vote_types(:positive)
    @post = posts(:problem1)
    @comment = comments(:comment1)
    @vote = Vote.new
  end

# Test Validation Works
  test "vote must have a user and vote type" do
    assert @vote.invalid?
    assert @vote.errors[:user_id].any?, "User must be present"
    assert @vote.errors[:vote_type_id].any?, "Vote type must be present"
  end
  
  test "vote has at least one post associated" do
    @vote.user_id = @user.id
    @vote.vote_type_id = @vote_type.id
    assert @vote.invalid?, "At least one post must be present"
    
    @vote.post_id = @post.id
    assert @vote.valid?, "Vote with one post present should be valid"
    
    @vote.comment_id = @comment.id
    assert @vote.invalid?, "Vote with more than one post present should not be valid"
  end
end
