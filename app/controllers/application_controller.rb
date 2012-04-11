class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper

  protect_from_forgery
  before_filter :prepare_for_mobile
  
  protected
  
  def clean_editor_input( text ) 
    if text.strip == "<br>"
      text = ""
    end
    sanitize text, :tags => %w(p div strong em ul ol li u blockquote br sub img a h1 h2 h3 span b), :attributes => %w(id class style)    
    conversion = {
        '<br>'=>'<br />',
        '<b>'=>'<strong>',
        '</b>'=>'</strong>',
        '<i>'=>'<em>',
        '</i>'=>'</em>'
    }
    # replace old html elements with new
    conversion.each do |e|
        text = text.gsub(e[0], e[1])
    end

    return text
  end
  
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
