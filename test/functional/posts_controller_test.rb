require 'test_helper'

class PostsControllerTest < ActionController::TestCase
# Load Test Data
fixtures :posts, :users, :error_messages, :categories, :tags

  def setup
    @problem = posts(:problem1)
    @solution = posts(:solution1)
    @problem.error_messages << error_messages(:error1)
    @problem.error_messages << error_messages(:error2)
    @problem.categories << categories(:os)
    @problem.categories << categories(:windows)    
    @problem.tags << tags(:tag1)
    @problem.tags << tags(:tag2)
  end

## Test actions index, list and show
 
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
    get :show, {:id => @problem.id}
    assert_response :success
    assert_template :show
  end  
  # should redirect shown problems to their parent
  test "get show with solution id" do
    get :show, {:id => @solution.id}
    assert_redirected_to :controller => "posts", :action => "show", :id => @solution.parent_id
  end 

## Test action create_solution
  test "should not get create_solution when logged out" do
    get :create_solution
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create_solution without id when logged in" do
    get :create_solution, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "posts", :action => "list"
  end
  
  test "get create_solution with problem id and no description posted when logged in" do
    get :create_solution, { :id => @problem.id }, { :user_id => users(:alice).id }
    assert_template :show
    assert_equal "Errors prevented the solution from saving" , flash[:notice]
  end  
  
  test "post valid description to create solution" do  
    post :create_solution, { :id => @problem.id, :post => { :description => "solution test" } }, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
    assert_equal "Solution Created" , flash[:notice]
  end
  
  test "post invalid description to create solution" do
    post :create_solution, { :id => @problem.id, :post => { :description => "" } }, { :user_id => users(:alice).id }
    assert_template :show
    assert_equal "Errors prevented the solution from saving" , flash[:notice]
  end
  
## Test action new

  test "should not get new when logged out" do
    get :new
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should get new when logged in" do
    get :new, {}, { :user_id => users(:alice).id }
    assert_response :success
    assert_template :new
  end

## Test action create

  test "should not get create when logged out" do
    get :create
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "get create when logged in and no params" do
    get :create, {}, { :user_id => users(:alice).id }
    assert_template :new
    assert_equal "Errors prevented the post from saving" , flash[:notice]
  end  
  
  test "create problem when logged in and with valid params" do
    post :create, { :post => { :title => "Test", :description => "Test", 
                    :error_messages_attributes => { "0" => { "description" => "TestError" }, "1" => { "description" => "TestError2" }}, 
                    :categories_attributes => { "0" => { "name" => "Operating Systems" }}, 
                    :tags_attributes => { "0" => {"name" => "Tag1" }}}}, 
                  { :user_id => users(:alice).id }
    assert_redirected_to :controller => "posts", :action => "list"
    assert_equal "Post Created" , flash[:notice]
  end
  
  test "create problem when logged in and with invalid params" do
    post :create, { :post => { :title => "Test", :description => "Test", 
                    :error_messages_attributes => { "0" => { "description" => "TestError" }, "1" => { "description" => "TestError2" }}, 
                    :categories_attributes => { "0" => { "name" => "" }},   # No Category entered, so should be invalid
                    :tags_attributes => { "0" => {"name" => "Tag1" }}}}, 
                  { :user_id => users(:alice).id }
    assert_template :new
    assert_equal "Errors prevented the post from saving" , flash[:notice]
  end
  
## Test action edit

  test "should not get edit when logged out" do
    get :edit
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

  test "should not get edit when logged in as standard user" do
    get :edit, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end

  test "should not get edit when logged in as admin and with no params id" do
    get :edit, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "list"
  end 

  test "should get edit when logged in as admin and with params id" do 
    get :edit, { :id => @problem.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :edit
  end
  
## Test action update

  test "should not get update when logged out" do
    get :update
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

  test "should not get update when logged in as standard user" do
    get :update, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end

  test "should not get update when logged in as admin and with no params id" do
    get :update, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "list"
  end 

  test "update should be successful when logged in as admin and with valid params id" do
    post :update, { :id => @problem.id, :post => { :title => @problem.title, :description => "New Description", 
                    :error_messages_attributes => { "0" => { "description" => @problem.error_messages[0] }, "1" => { "description" => @problem.error_messages[1] }}, 
                    :categories_attributes => { "0" => { "name" => @problem.categories[0] }},
                    :tags_attributes => { "0" => {"name" => @problem.tags[0] }}}}, 
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "show", :id => @problem.id
    assert_equal "Post Updated" , flash[:notice]
  end
  
  test "update should be unsuccessful when logged in as admin and with invalid params id" do
    post :update, { :id => @problem.id, :post => { :title => @problem.title, :description => "", 
                    :error_messages_attributes => { "0" => { "description" => @problem.error_messages[0] }, "1" => { "description" => @problem.error_messages[1] }}, 
                    :categories_attributes => { "0" => { "name" => @problem.categories[0] }},
                    :tags_attributes => { "0" => {"name" => @problem.tags[0] }}}}, 
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_template :edit
    assert_equal "Errors prevented the post from saving" , flash[:notice]
  end

## Test action delete

  test "should not get delete when logged out" do
    get :delete
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

  test "should not get delete when logged in as standard user" do
    get :delete, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end

  test "should not get delete when logged in as admin and with no params id" do
    get :delete, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "list"
  end 

  test "should get delete when logged in as admin and with params id" do 
    get :delete, { :id => @problem.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :delete
  end

## Test action destroy

  test "should not get destroy when logged out" do
    get :destroy
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

  test "should not get destroy when logged in as standard user" do
    get :destroy, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end

  test "should not get destroy when logged in as admin and with no params id" do
    get :destroy, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "list"
  end 

  test "should get destroy when logged in as admin and with params id" do 
    get :destroy, { :id => @problem.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "posts", :action => "list"
    assert_equal "Post Deleted" , flash[:notice]
  end
end
