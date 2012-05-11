require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
  end
  
  test "should get about" do
    get :about
    assert_response :success
    assert_template :about
  end  
  
  test "should get help" do
    get :help
    assert_response :success
    assert_template :help
  end
  
  test "should get faqs" do
    get :faqs
    assert_response :success
    assert_template :faqs
  end
  
  test "should get privacy policy" do
    get :privacy
    assert_response :success
    assert_template :privacy
  end
  
  test "should get terms of use" do
    get :termsofuse
    assert_response :success
    assert_template :termsofuse
  end     
        
end
