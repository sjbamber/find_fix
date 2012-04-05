class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prepare_for_mobile
  
  
  protected
  
  # BEFORE FILTER - Confirms that a user is logged in
  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'user_access', :action => 'login')
      return false # halts the before filter
    else
      return true
    end
  end
  
  # BEFORE FILTER - Confirms that a user is logged out
  def confirm_logged_out
    if session[:user_id]
      flash[:notice] = "You are already logged in"
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  # BEFORE FILTER - Confirms that a user is an admin
  def confirm_admin_role
    unless session[:role] == 2
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  # BEFORE FILTER - Confirms that a user is an admin OR they are logged out
  def confirm_admin_or_logged_out
    unless session[:role] == 2 || !session[:user_id]
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'public', :action => 'index')
      return false # halts the before filter
    else
      return true
    end
  end
  
  # BEFORE FILTER - Confirms that an id has been passed in params (i.e. GET or POST)
  def confirm_params_id
    if params[:controller] == "solutions" || params[:controller] == "comments" || params[:controller] == "votes"
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
    if mobile_device?
      request.format == :js ? request.format = :js : request.format = :mobile
    end
  end
  
end
