class UserAccessController < ApplicationController
  
  layout :choose_layout
  
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
    if params[:username] && params[:password] && permitted_user = User.authenticate(params[:username].downcase.strip, params[:password].downcase.strip)
      # Set the user to be logged in
      session[:user_id] = permitted_user.id
      session[:username] = permitted_user.username
      session[:role] = permitted_user.role
      flash[:notice] = "Welcome #{session[:username]}. You are now logged in"
      respond_to do |format|
        format.html{
          view_context.is_admin ? redirect_to(:action => 'admin_menu') : redirect_to(root_url)
        }
        format.mobile{
          view_context.is_admin ? redirect_to(:action => 'admin_menu') : redirect_to(root_url)
        }
        format.js { 
          render :action => :redirect 
        }
      end
    else
      respond_to do |format|
        format.html{
          flash[:notice] = "Invalid Username or Password"
          render('login')
        }
        format.mobile{
          flash[:notice] = "Invalid Username or Password"
          render('login')
        }
        format.js {
          @notice = "Invalid Username or Password"
        }           
      end
    end
  end
  
  def logout
    # Logs the user out and redirects them to the login page
      session[:user_id] = nil
      session[:username] = nil
      session[:role] = nil
      reset_session
      flash[:notice] = "You have been logged out"
      redirect_to(root_url)
  end
  
  private  
  
  def choose_layout  
    (request.xhr? && !view_context.mobile_device?) ? nil : 'application'  
  end 
  
end
