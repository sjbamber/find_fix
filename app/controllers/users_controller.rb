class UsersController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:index, :new, :create]
  before_filter :confirm_admin_role, :except => [:index, :new, :create]
  before_filter :confirm_admin_or_logged_out, :only => [:index, :new, :create]
  
  def index
      new
      render('new') 
  end
  
  def list
      @users = User.sorted
  end
  
  def new
      @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # If save succeeds, log the user in and redirect to the login page
      unless view_context.is_logged_in
        session[:user_id] = @user.id
        session[:username] = @user.username
        session[:role] = @user.role
        flash[:notice] = "User account registered. You are now signed in"
        redirect_to(:controller => 'posts')
      else
        flash[:notice] = "User account registered"
        redirect_to(:controller => 'users', :action => 'list' )
      end
      
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
