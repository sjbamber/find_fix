class UsersController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:index, :new, :create]
  before_filter :confirm_admin_role, :except => [:index, :new, :create]
  
  def index
    unless view_context.is_admin || !view_context.is_logged_in
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'welcome', :action => 'index')   
    else
      new
      render('new')
    end  
  end
  
  def list
      @users = User.sorted
  end
  
  def new
    unless view_context.is_admin || !view_context.is_logged_in
      flash[:notice] = "You are not permitted to access the requested page."
      redirect_to(:controller => 'welcome', :action => 'index')  
    else
      @user = User.new
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # If save succeeds, redirect to the login page
      flash[:notice] = "User Registered"
      redirect_to(:controller => 'user_access', :action => 'login')
    else
      # If save fails, redisplay the form so user can fix posts
      render('new')
    end
  end
  
  def edit
    # Find object using form parameters
    @user = User.find(params[:id])
  end
  
  def update
     # Find object using form parameters
    @user = User.find(params[:id])
    # Update the object
    if @user.update_attributes(params[:user])
      # If update succeeds, redirect back to the list
      flash[:notice] = "User Details Updated"
      redirect_to(:action => 'list')
    else
      # If update fails, redisplay the form so user can fix posts
      render('edit')
    end     
  end
  
  def delete
    @user = User.find(params[:id])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "User Deleted"
    redirect_to(:action => 'list')
  end
  
end
