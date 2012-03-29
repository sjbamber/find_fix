class ApplicationController < ActionController::Base
  before_filter :prepare_for_mobile
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
  
  def confirm_logged_out
    if session[:user_id]
      flash[:notice] = "You are already logged in"
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  def confirm_admin_role
    unless session[:role] == 2
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  def confirm_admin_or_logged_out
    unless session[:role] == 2 || !session[:user_id]
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  # Checks that an id is passed in params
  def confirm_params_id
    if params[:controller] == "solutions" || params[:controller] == "comments"
      params[:id] ? true : redirect_to(:controller => 'posts', :action => 'list'); false
    else
      params[:id] ? true : redirect_to(:action => 'list'); false
    end
  end
  
  # ***End of Before Filters***
  
  private
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS|iPhone/
    end
  end
  helper_method :mobile_device?
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
  
end
