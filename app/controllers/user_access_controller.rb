class UserAccessController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:index, :login, :process_login]
  before_filter :confirm_admin_role, :only => :admin_menu
  before_filter :confirm_logged_out, :only => [:login, :process_login]
  
  def index
    render('login')
  end
  
  def admin_menu
    # Display admin menu
  end

  def login
    # Displays the login form
    
  end
  
  def process_login
    # Carries out the login procedure
    if permitted_user = User.authenticate(params[:username].downcase.strip, params[:password].downcase.strip)
      # Set the user to be logged in
      session[:user_id] = permitted_user.id
      session[:username] = permitted_user.username
      session[:role] = permitted_user.role
      flash[:notice] = "You are now logged in"
      if view_context.is_admin
        redirect_to(:action => 'admin_menu')
      else
        redirect_to(:controller => 'public', :action => 'index')
      end
    else 
      flash[:notice] = "Invalid Username or Password"
      render('login')
    end
  end
  
  def logout
    # Logs the user out and redirects them to the login page
      session[:user_id] = nil
      session[:username] = nil
      session[:role] = nil
      flash[:notice] = "You have been logged out"
      redirect_to(:action => 'login')
  end
  
end
