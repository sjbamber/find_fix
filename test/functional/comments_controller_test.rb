require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :solutions, :comments, :users, :categories, :tags

  def setup
    @user = users(:alice)
    @problem = posts(:problem1)
    @problem.categories << categories(:windows)
    @problem.tags << tags(:tag1)
    @problem.user = @user
    @problem.save
    @solution = solutions(:solution1)
    @solution.user = users(:testuser1)
    @solution.post = @problem
    @solution.save
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

  test "post valid post comment to create" do
    post :create, { :id => @problem.id, :problem_id => @problem.id, :post_type => @problem.class, :comment => { :comment => "test comment" } }, { :user_id => @user.id }
    assert @problem.valid?, @problem.errors.full_messages.to_s
    assert assigns(:comment).comment == "test comment"
    assert_equal "Comment Submitted Successfully", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  
  test "post valid solution comment to create" do  
    post :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => @solution.class, :comment => { :comment => "test comment" } }, { :user_id => @user.id }
    assert @solution.valid?, @solution.errors.full_messages.to_s
    assert assigns(:comment).comment == "test comment"
    assert_equal "Comment Submitted Successfully", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end

  test "post invalid post comment to create" do
    post :create, { :id => @problem.id, :problem_id => @problem.id, :post_type => @problem.class, :comment => { :comment => "" } }, { :user_id => @user.id }
    assert_template 'posts/show'
    assert_equal "Errors prevented the comment from saving" , flash[:notice]
  end
  
  test "post invalid solution comment to create" do
    post :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => @solution.class, :comment => { :comment => "" } }, { :user_id => @user.id }
    assert_template 'posts/show'
    assert_equal "Errors prevented the comment from saving" , flash[:notice]
  end
  
  ## Test Create with AJAX
  test "post valid solution comment to create via AJAX" do
    xhr :post, :create, { :id => @solution.id, :problem_id => @problem.id, :post_type => @solution.class, :comment => { :comment => "test comment" } }, { :user_id => @user.id }
    assert_response :success
    assert assigns(:comment).comment == "test comment"
  end
end
