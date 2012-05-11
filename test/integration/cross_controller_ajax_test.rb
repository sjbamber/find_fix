require 'test_helper'

class CrossControllerAjaxTest < ActionDispatch::IntegrationTest

fixtures :posts, :solutions, :comments, :users, :vote_types, :categories, :tags

  def setup
    @user = users(:alice) 
    @problem = posts(:problem1)
    @problem.categories << categories(:windows)
    @problem.tags << tags(:tag1)
    @problem.user = users(:testuser1)
    @problem.save
  end

  test "get post create solution and comment on it via AJAX then try to vote on problem solution and comment via AJAX" do
    
    # Login
    get "/user_access/login"
    assert_response :success
    assert_template "login"
    post "/user_access/process_login", :username => @user.username, :password => 'password'
    assert_redirected_to :controller => "public", :action => "index"
    assert_equal "Welcome #{@user.username}. You are now logged in" , flash[:notice]
    assert_equal @user.id, session[:user_id] # (confirm logged in)
    
    # Get Post
    get "/posts/show/#{@problem.id}"
    assert_response :success
    assert_template "show"
    assert_select "div#content" do
      assert_select "h2" , @problem.title
    end
    
    # Post solution via AJAX ( Has no solutions, comments or votes yet)
    xhr :post, "solutions/create", {:id => @problem.id, :solution => { :description => "This is a great solution to the problem." } }, { :user_id => session[:user_id] }
    assert_response :success
    # Test the response is as expected
    assert_match /solution#{assigns(:solution).id}.*This is a great solution to the problem/, @response.body
    solution = assigns(:solution)
    
    # Post comment on the solution via AJAX
    xhr :post, "comments/create", { :id => solution.id, :problem_id => @problem.id, :post_type => solution.class, :comment => { :comment => "test comment" } }, { :user_id => session[:user_id] }
    assert_response :success
    # Test the response is as expected
    assert_match /comment#{assigns(:comment).id}.*test comment/, @response.body
    comment = assigns(:comment)
    
    # Vote on the problem via AJAX
    problem_score = @problem.get_score
    xhr :post, "votes/create", { :id => @problem.id, :problem_id => @problem.id, :post_type => @problem.class, :vote_type => "positive" }, { :user_id => session[:user_id] }
    assert_response :success
    # Test the response is as expected
    assert_match /score_post#{@problem.id}.*score_value.*#{problem_score+1}/, @response.body
    
    # Vote on the solution via AJAX
    solution_score = solution.get_score
    xhr :post, "votes/create", { :id => solution.id, :problem_id => @problem.id, :post_type => solution.class, :vote_type => "positive" }, { :user_id => session[:user_id] }
    assert_response :success
    # Test the response is as expected
    assert_match /score_solution#{solution.id}.*score_value.*#{solution_score}/, @response.body
    assert_match /Vote Failed. You cannot vote on a solution that you created/, @response.body
    
    # Vote on the comment via AJAX
    comment_score = comment.get_score
    xhr :post, "votes/create", { :id => comment.id, :problem_id => @problem.id, :post_type => comment.class, :vote_type => "negative" }, { :user_id => session[:user_id] }
    assert_response :success
    # Test the response is as expected
    assert_match /score_comment#{comment.id}.*score_value.*#{comment_score}/, @response.body
    assert_match /Vote Failed. You cannot vote on a comment that you created/, @response.body
    
  end  

end
