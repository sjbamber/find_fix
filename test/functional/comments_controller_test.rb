require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :solutions, :comments, :users

  def setup
    @user = users(:alice)
    @solution = solutions(:solution1)
    @problem = posts(:problem1)
    @comment = comments(:comment1)
  end
  
  ## Test action create
  test "get create when logged out" do
    get :create
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create without id when logged in" do
    get :create, {}, { :user_id => @user.id }
    assert_redirected_to :controller => "posts", :action => "list"
  end
  
  test "get create with problem id and no comment posted or post type when logged in" do
    get :create, { :id => @problem.id }, { :user_id => @user.id }
    assert_template 'posts/show'
    assert_equal "Errors prevented the comment from saving" , flash[:notice]
  end  
  
  test "post valid comment to create" do  
    post :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => 'Solution', :comment => { :comment => "test comment" } }, { :user_id => @user.id }
    assert_equal "Comment Submitted Successfully", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  
  test "post invalid comment to create" do
    post :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => 'Solution', :comment => { :comment => "" } }, { :user_id => @user.id }
    assert_template 'posts/show'
    assert_equal "Errors prevented the comment from saving" , flash[:notice]
  end
  
end
