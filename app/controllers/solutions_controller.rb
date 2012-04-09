class SolutionsController < ApplicationController
  before_filter :confirm_logged_in#, :except => [:index, :list, :show]
  #before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id#, :only => [:show, :edit, :update, :delete, :destroy]  
  
  def create
    begin   
      @solution = Solution.new(params[:solution])
      @solution.description = clean_editor_input(@solution.description) #process description being entered from custom textarea
      @solution.user = User.find_by_id(session[:user_id])
      @solution.post = Post.find_by_id(params[:id])
      @solution.save!
      respond_to do |format|
        format.html { 
          flash[:notice] = "Fix Submitted Successfully"
          redirect_to(:controller => 'posts', :action => 'show', :id => params[:id])
        }
        format.mobile { 
          flash[:notice] = "Fix Submitted Successfully"
          redirect_to(:controller => 'posts', :action => 'show', :id => params[:id])
        }
        format.js {
          @notice = "Fix Submitted Successfully"
          @comment = Comment.new
        }
      end  
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      @comment = Comment.new
      respond_to do |format|
        format.html { 
          flash[:notice] = "Errors prevented the solution from saving"
          # Render the view again
          @post = Post.find_by_id(params[:id])
          @solutions = Solution.where(:post_id => params[:id])
          render('posts/show')
        }
        format.mobile { 
          flash[:notice] = "Errors prevented the solution from saving"
          # Render the view again
          @post = Post.find_by_id(params[:id])
          @solutions = Solution.where(:post_id => params[:id])
          render('posts/show')
        }
        format.js {
          @notice = "Errors prevented the solution from saving"
        }
      end
    end
  end 
end
