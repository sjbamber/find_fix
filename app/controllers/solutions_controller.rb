class SolutionsController < ApplicationController
  before_filter :confirm_logged_in#, :except => [:index, :list, :show]
  #before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id#, :only => [:show, :edit, :update, :delete, :destroy]  
  
  def create
    begin   
      @solution = Solution.new(params[:solution])
      @solution.user = User.find_by_id(session[:user_id])
      @solution.post = Post.find_by_id(params[:id])
      @solution.save!
      
      flash[:notice] = "Fix Submitted Successfully"
      redirect_to(:controller => 'posts', :action => 'show', :id => params[:id])
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      flash[:notice] = "Errors prevented the solution from saving"
      # Render the view again
      @post = Post.find_by_id(params[:id])
      @solutions = Solution.where(:post_id => params[:id])
      @comment = Comment.new
      render('posts/show')
    end
  end 
end
