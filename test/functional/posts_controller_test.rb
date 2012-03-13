require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "test get index without user" do
    get :index
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
end
