require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
fixtures :posts, :users, :error_messages, :categories, :tags

  def setup
    @user = users(:alice)
  end

  
  test "new user registering a new account and posting a new problem" do
    # We need to check a new user and post are created so these are cleared first
    Post.delete_all
    User.delete_all
    
    ### USER STORY START ###
    
    # A user goes to the index page.
    get "/"
    assert_response :success
    assert_template "index"
    
    # The user selects register user.
    get "/users/new"
    assert_response :success
    assert_template "new"
    
    # They fill out their details, click 'submit'.
    post "/users/create", :user => { :name => "Joe Bloggs", :email => "jbloggs@uclan.ac.uk", :email_confirmation => "jbloggs@uclan.ac.uk",
                  :username => "jbloggs", :password => "password1", :password_confirmation => "password1" }
    
    # When they submit, a user record is created in the database containing this information. 
    # (check the user is in the database and correct)
    users = User.all
    assert_equal 1, users.size
    user = users[0]
    
    assert_equal "Joe Bloggs", user.name
    assert_equal "jbloggs@uclan.ac.uk", user.email
    assert_equal "jbloggs", user.username
                  
    # The user is redirected to a list of posts...
    assert_redirected_to :controller => "posts", :action => "index"
    
    # ...and are automatically logged into their new account.
    assert_equal "jbloggs", session[:username]
    assert_equal "User account registered. You are now signed in", flash[:notice]
    
    # They select submit a new problem and are presented with the post new problem form.
    get "/posts/new"
    assert_response :success
    assert_template "new"
    
    # They enter a title, description, error message and tags and select a category before submitting the problem. 
    post "/posts/create", { :post => { :title => "Problem Title", :description => "Description of Problem", 
                    :error_messages_attributes => { "0" => { "description" => "Problem Error" }, "1" => { "description" => "Another Error" }}, 
                    :categories_attributes => { "0" => { "name" => "Operating Systems" }}, 
                    :tags_attributes => { "0" => {"name" => "Problem Tag" }}}}, 
                  { :user_id => User.find_by_username("jbloggs").id }
                  
    # When they submit, a problem post is created in the database containing this information, along with an association of their user account to it. 
    # (check the post is in the database and correct)
    posts = Post.all
    assert_equal 1, posts.size
    post = posts[0]
    
    assert_equal "Problem Title", post.title
    assert_equal "Description of Problem", post.description
    assert_equal 0, post.post_type
    assert_equal "jbloggs", post.user.username
    assert_equal "Problem Error", post.error_messages[0].description
    assert_equal "Another Error", post.error_messages[1].description
    assert_equal "Operating Systems", post.categories[0].name
    assert_equal "Problem Tag", post.tags[0].name    
    
    # Following the submission the user is redirected to the post view containing the information they have just entered and they are notified the post was created successfully.
    assert_redirected_to :controller => "posts", :action => "show", :id => assigns(:post).id
    assert_equal "Post Created" , flash[:notice]
  end
  
  test "existing user logging in searching for and locating an existing problem and posting a new fix" do
    # A user goes to the index page...
    get "/"
    assert_response :success
    assert_template "index"
    
    # ...and selects login.
    get "/user_access/login"
    assert_response :success
    assert_template "login"
      
    # They enter their username and password and click 'Log In'.  
    post "/user_access/process_login", :username => @user.username, :password => 'password'
    # They are redirected to a page displaying a list of problems and are notified that they logged in successfully
    assert_redirected_to :controller => "posts", :action => "index"
    assert_equal "You are now logged in" , flash[:notice]
    assert_equal @user.id, session[:user_id] # (confirm logged in)
    
    # They cannot immediately see the problem they are looking for, so they search for the problem using the box at the top of the screen and enter some keywords. 
    get "/posts/list?query=control+panel" # Enter keywords 'control panel
    
    # They are directed to the list page containing results of the search. 
    assert_template "list"
    # They find the problem record they are looking for in the list...
    assert_equal 1, assigns(:posts).size
    retrieved_post = assigns(:posts)[0] # Get the post retrieved by the search
    assert_equal "Control Panel Applet cannot be loaded", retrieved_post.title
    
    # ...and click on it to bring up the post view.  
    get "/posts/show/#{retrieved_post.id}"
    assert_response :success
    assert_template "show"
    assert_select "div#content_header" do
      assert_select "h2" , retrieved_post.title
    end  
    
    # They read the post, then enter details of what they believe to be a fix in the box provided and click ‘submit fix’.
    post "posts/create_solution", {:id => retrieved_post.id, :post => { :description => "This is a great solution to the problem." } }, { :user_id => @user.id }
    # The page is refreshed to display the submitted fix to the user and they are given a notification that the fix has been submitted.
    assert_redirected_to :controller => "posts", :action => "show", :id => retrieved_post.id
    assert_equal "Fix Submitted" , flash[:notice]
    
    # (Test the fix is stored in the DB)
    fixes = Post.where("parent_id=#{retrieved_post.id}")
    assert_equal 1, fixes.size
    fix = fixes[0]
    assert_equal "This is a great solution to the problem.", fix.description

    # (Test the fix is displayed on the page)
    get "/posts/show/#{retrieved_post.id}"
    assert_select "p" , fix.description
  end

end
