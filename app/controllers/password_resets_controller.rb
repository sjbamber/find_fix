class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    flash[:notice] = "An email has been sent to #{params[:email]} with further details on how to reset you password."
    redirect_to(:controller => 'public', :action => 'index')
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:notice] = "Your password reset request has expired. You must respond to the password reset request within 2 hours. Please try again."
      redirect_to( :action => 'new')  
    elsif @user.update_attributes(params[:user])
      flash[:notice] = "Password Reset Successful!"
      redirect_to(:controller => 'user_access', :action => 'login')
    else  
      render('edit')
    end
  end
end
