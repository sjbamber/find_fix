require 'test_helper'

class UserAccessControllerTest < ActionController::TestCase

  test "should get login" do
    get :login
    assert_response :success
  end

  test "test get admin menu without user" do
    get :admin_menu
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end

end
