require 'test_helper'

class VotesControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :solutions, :comments, :users, :vote_types, :categories, :tags

  def setup
    @user = users(:alice)
    @problem = posts(:problem1)
    @problem.categories << categories(:windows)
    @problem.tags << tags(:tag1)
    @problem.user = users(:testuser1)
    @problem.save
    @solution = solutions(:solution1)
    @solution.post = @problem
    @solution.save
    @comment = comments(:comment1)
    @comment.post = @problem
    @comment.save
    @vote_type_positive = vote_types(:positive)
    @vote_type_negative = vote_types(:negative)
    
    @voted_on_post = posts(:problem2) # problem that has already been voted on
    @existing_vote = Vote.create(:vote_type_id => @vote_type_positive.id, :user_id => @user.id, :post_id => @voted_on_post.id)
    
    @solution_created_by_user = solutions(:solution2) # post created by @user
    @solution_created_by_user.post = @problem
    @solution_created_by_user.user = @user 
    @solution_created_by_user.save
    
    @vote = Vote.new
  end
  
  ## Test action create
  
  # Test Before Filters
  test "get create when logged out" do
    get :create
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create without id when logged in" do
    get :create, {}, { :user_id => @user.id }
    assert_redirected_to :controller => "posts", :action => "list"
  end
  
  # Test create content
  test "get create with problem id and no additional params" do
    get :create, { :id => @problem.id }, { :user_id => @user.id }
    assert_equal "An error occured", flash[:notice]
    assert_redirected_to :controller => "public", :action => "index"
  end  

  # Test successful votes for all post types positive and negative
  test "post valid positive vote for a problem" do
    post :create, { :id => @problem.id, :problem_id => @problem.id, :post_type => @problem.class, :vote_type => "positive" }, { :user_id => @user.id }
    assert_equal "Post Vote Successful", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  test "post valid negative vote for a solution" do
    post :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => @solution.class, :vote_type => "negative" }, { :user_id => @user.id }
    assert_equal "Solution Vote Successful", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  test "post valid positive vote for a comment" do
    post :create, { :id => @comment.id, :problem_id => @problem.id, :post_type => @comment.class, :vote_type => "negative" }, { :user_id => @user.id }
    assert_equal "Comment Vote Successful", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end  

  # Test vote failure
  test "post a vote to a problem when you have already voted before" do
    post :create, { :id => @voted_on_post.id, :problem_id => @voted_on_post.id, :post_type => @voted_on_post.class, :vote_type => "positive" }, { :user_id => @user.id }
    assert_equal "Vote Failed. You have already voted on this post", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @voted_on_post.id
  end

  test "post a vote to a solution you created" do
    post :create, { :id => @solution_created_by_user.id, :problem_id => @problem.id, :post_type => @solution_created_by_user.class, :vote_type => "negative" }, { :user_id => @user.id }
    assert_equal "Vote Failed. You cannot vote on a solution that you created.", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  
end
