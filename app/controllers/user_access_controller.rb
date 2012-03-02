class UserAccessController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:login, :process_login, :logout]
  
  def index
    menu
    render('menu')
  end

  def login
    # Displays the login form
    
  end
  
  def process_login
    # Carries out the login procedure
    permitted_user = User.authenticate(params[:username], params[:password])
    if permitted_user
      # Set the user to be logged in
      session[:user_id] = permitted_user.id
      session[:username] = permitted_user.username
      flash[:notice] = "You are now logged in"
      redirect_to(:controller => 'posts')
    else 
      flash[:notice] = "Invalid Username or Password"
      redirect_to(:action => 'login')
    end
  end
  
  def logout
    # Logs the user out and redirects them to the login page
      session[:user_id] = nil
      session[:username] = nil
      flash[:notice] = "You have been logged out"
      redirect_to(:action => 'login')
  end
  
end
