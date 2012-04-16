require 'test_helper'

class UserAccessControllerTest < ActionController::TestCase
# Load Test Data
fixtures :users

## Test can get index, login and process login when logged out
  test "index renders login" do
    get :index
    assert_template :login
  end

  test "should get login" do
    get :login
    assert_response :success
    assert_template :login
  end
  
  test "should get process login" do
    get :process_login
    assert_response :success
    assert_template :login
  end  

## Test can't get admin_menu and logout when logged out
  test "test get admin menu without user" do
    get :admin_menu
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

  test "test get logout when not logged in" do
    get :logout
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
## Tests When Logged in as standard user
  # should fail to get admin page when logged in as standard user 
  test "test get admin menu logged in with standard user" do
    get :admin_menu, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end
  
  # should logout successfully when logged in
  test "test logout when logged in" do
    get :logout, {}, { :user_id => users(:alice).id }
    assert_redirected_to root_url
    assert_equal "You have been logged out" , flash[:notice]
  end 
  
  # should not be able to access login or process login, when logged in
  test "test accessing login when logged in" do
    get :login, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are already logged in" , flash[:notice]
  end   
  
  test "test accessing process login when logged in" do
    get :process_login, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are already logged in" , flash[:notice]
  end    
  
## Tests When Logged in as administrator
  # should get admin menu when logged in as administrator
  test "test get admin menu logged in as administrator" do
    get :admin_menu, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :admin_menu
  end
  
## Tests successful login for standard user and admin
  test "test login of standard user is successful with correct username and password" do
    alice = users(:alice)
    post :process_login, :username => alice.username, :password => 'password'
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "Welcome #{alice.username}. You are now logged in" , flash[:notice]
    assert_equal alice.id, session[:user_id]
  end
  
  test "test login of administrator is successful with correct username and password" do
    administrator = users(:administrator)
    post :process_login, :username => administrator.username, :password => 'password'
    assert_redirected_to :controller => "user_access", :action => "admin_menu"
    assert_equal "Welcome administrator. You are now logged in" , flash[:notice]
    assert_equal administrator.id, session[:user_id]
  end  

## Tests unsuccessful login with incorrect username or password
  test "test login fails with incorrect username" do
    post :process_login, :username => 'unknown', :password => 'password'
    assert_template :login
    assert_equal "Invalid Username or Password" , flash[:notice]
  end

  test "test login fails with incorrect password" do
    alice = users(:alice)
    post :process_login, :username => alice.username, :password => 'wrongpassword'
    assert_template :login
    assert_equal "Invalid Username or Password" , flash[:notice]
  end
  
end
