require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :solutions, :users

  def setup
    @solution = solutions(:solution1)
    @problem = posts(:problem1)
    @problem.categories << categories(:windows)
    @problem.tags << tags(:tag1)
    @problem.user = users(:alice)
    @problem.save
  end
  
  ## Test action create
  test "get create when logged out" do
    get :create
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create without id when logged in" do
    get :create, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "posts", :action => "list"
  end
  
  test "get create with problem id and no description posted when logged in" do
    get :create, { :id => @problem.id }, { :user_id => users(:alice).id }
    assert_template :show
    assert_equal "Errors prevented the solution from saving" , flash[:notice]
  end  
  
  test "post valid description to create" do  
    post :create, { :id => @problem.id, :solution => { :description => "solution test" } }, { :user_id => users(:alice).id }
    assert_equal "Fix Submitted Successfully", flash[:notice]
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
  end
  
  test "post invalid description to create" do
    post :create, { :id => @problem.id, :post => { :description => "" } }, { :user_id => users(:alice).id }
    assert_template :show
    assert_equal "Errors prevented the solution from saving" , flash[:notice]
  end
  
end
