require 'test_helper'

class PostsControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :users

## Test actions index list and show
 
  test "index renders list" do
    get :index
    assert_template :list
  end
  
  test "get list" do
    get :list
    assert_response :success
    assert_template :list
  end

  test "get show without id" do
    get :show
    assert_redirected_to :controller => "posts", :action => "list"
  end

  test "get show with problem id" do
    post = posts(:problem1)
    get :show, {:id => post.id}
    assert_response :success
    assert_template :show
  end  
  # should redirect shown problems to their parent
  test "get show with solution id" do
    post = posts(:solution1)
    get :show, {:id => post.id}
    assert_redirected_to :controller => "posts", :action => "show", :id => post.parent_id
  end 

## Test action create_solution
  test "should not get create_solution when logged out" do
    get :create_solution
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create_solution without id when logged in" do
    get :create_solution, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create_solution with problem id when logged in" do
    post = posts(:problem1)
    get :create_solution, { :id => post.id }, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end  
  
end
