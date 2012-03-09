class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  # ***Before Filters***
  
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
    params[:id] ? true : redirect_to(:action => 'list'); false
  end
  
  # ***End of Before Filters***
  
  def get_category_list
    @categories = Category.sort_by_ancestry(Category.all)
  end
  
  def get_tag_list
    @tags = Tag.all
  end
  
end
