require 'test_helper'

class UsersControllerTest < ActionController::TestCase
# Load Test Data
fixtures :users

## Tests for when user is logged out and no params passed

  test "index renders new" do
    get :index
    assert_template :new
  end
  
  test "should get new when logged out" do
    get :new
    assert_response :success
    assert_template :new
  end
  
  test "direct access or invalid input to create should render new when logged out" do
    get :create
    assert_response :success
    assert_equal "User Registration Failed" , flash[:notice]
    assert_template :new
  end
  
  test "should not get list when logged out" do
    get :list
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end  
  
  test "should not get edit when logged out" do
    get :edit
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should not get update when logged out" do
    get :update
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should not get delete when logged out" do
    get :delete
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should not get destroy when logged out" do
    get :destroy
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
## Test creation of users when logged out and passed params from insert form

  test "test create user with valid input when logged out" do
    post :create, :user => { :name => "John Smith", :email => "jsmith1@uclan.ac.uk", :email_confirmation => "jsmith1@uclan.ac.uk",
                  :username => "jsmith1234", :password => "password", :password_confirmation => "password" }
    assert_redirected_to :controller => "posts", :action => "index"
    assert_equal "User account registered. You are now signed in", flash[:notice]
  end
  
## Tests for when user is logged in as standard user (No actions accessible)
  test "should not get index when logged in as standard user" do
    get :index, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end
  
  test "should not get new when logged in as standard user" do
    get :new, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end  

  test "should not get create when logged in as standard user" do
    get :create, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end  

  test "should not get list when logged in as standard user" do
    get :list, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end
  
  test "should not get edit when logged in as standard user" do
    get :edit, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end

  test "should not get update when logged in as standard user" do
    get :update, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end
  
  test "should not get delete when logged in as standard user" do
    get :delete, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end
  
  test "should not get destroy when logged in as standard user" do
    get :destroy, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end    
  
## Tests for when administrator is logged in
  test "index renders new logged in as admin" do
    get :index, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :new
  end

  test "should get list when logged in as admin" do
    get :list, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :list
  end

  test "should get new when logged in as admin" do
    get :new, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :new
  end

  test "should get create when logged in as admin" do
    post :create, { :user => { :name => "John Smith", :email => "jsmith1@uclan.ac.uk", :email_confirmation => "jsmith1@uclan.ac.uk",
                    :username => "jsmith1234", :password => "password", :password_confirmation => "password" } }, 
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_equal "User account registered", flash[:notice]
    assert_redirected_to :controller => "users", :action => "list"
  end
  
  test "should get edit when logged in as admin" do
    alice = users(:alice)
    get :edit, {:id => alice.id}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :edit
  end  

  test "should get update when logged in as admin" do
    alice = users(:alice)
    post :update, { :id => alice.id, :user => { :name => alice.name, :email => alice.email,
                  :username => alice.username, :password => "alicepass", :password_confirmation => "alicepass" } }, 
                { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_equal "User Details Updated", flash[:notice]
    assert_redirected_to :controller => "users", :action => "list"
  end 
  
  test "update should fail with invalid input" do
    alice = users(:alice)
    post :update, { :id => alice.id, :user => { :name => alice.name, :email => "aliceemail",
                  :username => "", :password => "", :password_confirmation => "" } }, 
                { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_equal "User Update Failed", flash[:notice]
    assert_template :edit
  end 
  
  test "should get delete when logged in as admin" do
    alice = users(:alice)
    get :delete, {:id => alice.id}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :delete
  end  
  
  test "should get destroy when logged in as admin" do
    alice = users(:alice)
    get :destroy, {:id => alice.id}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_equal "User Deleted", flash[:notice]
    assert_redirected_to :controller => "users", :action => "list"
  end  
  
end
