require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
# Load Test Data
fixtures :categories, :users

  def setup
    @category = categories(:os)
    @category_with_parent = categories(:windows)
    @category_with_parent.parent = @category
    @category2 = categories(:xp)
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
    assert_redirected_to :controller => "categories", :action => "list"
  end

  test "get show with category id" do
    get :show, {:id => @category.id}
    assert_response :success
    assert_template :show
  end  
  
## Test action new

  test "should not get new when logged out" do
    get :new
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should not get new when logged in as standard user" do
    get :new, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end  
  
  test "should get new when logged in as administrator" do
    get :new, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_response :success
    assert_template :new
  end

## Test action create

  test "should not get create when logged out" do
    get :create
    assert_redirected_to :controller => "user_access", :action => "login"
    assert_equal "Please log in." , flash[:notice]
  end
  
  test "should not get create when logged in as standard user" do
    get :create, {}, { :user_id => users(:alice).id }
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "You are not permitted to access the requested page." , flash[:notice]
  end    
  
  test "get create when logged in as admin and no params" do
    get :create, {}, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_template :new
    assert_equal "Errors prevented the category from saving" , flash[:notice]
  end  
  
  test "create category successful when logged in as admin and with valid params" do
    post :create, { :category => { :name => "Test", :parent_id => @category.id }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "list"
    assert_equal "Category Created" , flash[:notice]
  end
  
  test "create category fails when logged in as admin and with invalid params" do
    post :create, { :category => { :name => "", :parent_id => @category.id }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_template :new
    assert_equal "Errors prevented the category from saving" , flash[:notice]
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
    assert_redirected_to :controller => "categories", :action => "list"
  end 

  test "should get edit when logged in as admin and with params id" do 
    get :edit, { :id => @category.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
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
    assert_redirected_to :controller => "categories", :action => "list"
  end 

  test "update should be successful when logged in as admin and with params id and valid form data" do
    post :update, {:id => @category.id, :category => { :name => "new name", :parent_id => nil }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "show", :id => @category.id
    assert_equal "Category Updated" , flash[:notice]
  end
  
  test "update should be unsuccessful when logged in as admin and with params id and invalid form data" do
    post :update, {:id => @category.id, :category => { :name => "", :parent_id => nil }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_template :edit
    assert_equal "Errors prevented the category from updating" , flash[:notice]
  end

  test "update category with a parent to have a blank parent" do
    post :update, {:id => @category_with_parent.id, :category => { :name => @category_with_parent.name, :parent_id => nil }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "show", :id => @category_with_parent.id
    assert_equal "Category Updated" , flash[:notice]
  end 
  
  test "update category with blank parent to have a parent" do
    post :update, {:id => @category2.id, :category => { :name => @category2.name , :parent_id => @category.id }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "show", :id => @category2.id
    assert_equal "Category Updated" , flash[:notice]
  end
  
  test "update category with a parent to have a different parent" do
    post :update, {:id => @category_with_parent.id, :category => { :name => @category_with_parent.name, :parent_id => @category2.id }},
                  { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "show", :id => @category_with_parent.id
    assert_equal "Category Updated" , flash[:notice]
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
    assert_redirected_to :controller => "categories", :action => "list"
  end 

  test "should get delete when logged in as admin and with params id" do 
    get :delete, { :id => @category.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
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
    assert_redirected_to :controller => "categories", :action => "list"
  end 

  test "should get destroy when logged in as admin and with params id" do 
    get :destroy, { :id => @category.id }, { :user_id => users(:administrator).id, :role => users(:administrator).role }
    assert_redirected_to :controller => "categories", :action => "list"
    assert_equal "Category Deleted" , flash[:notice]
  end
end
