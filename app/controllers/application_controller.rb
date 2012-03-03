class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'user_access', :action => 'login')
      return false # halts the before filter
    else
      return true
    end
  end
  
  def confirm_admin_role
    unless session[:role] == 2
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'welcome', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
end
