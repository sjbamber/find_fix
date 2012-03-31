class CommentsController < ApplicationController
  before_filter :confirm_logged_in#, :except => [:index, :list, :show]
  #before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id#, :only => [:show, :edit, :update, :delete, :destroy]  
  
  def create
      if params[:comment] 
        @comment = Comment.new(params[:comment])
        @comment.user = User.find_by_id(session[:user_id])
      else
        @comment = Comment.new
      end
      
      comment_error = false
      if params[:post_type] && params[:post_type] == "Post"
        @comment.post = Post.find_by_id(params[:id])
      elsif params[:post_type] && params[:post_type] == "Solution"
        @comment.solution = Solution.find_by_id(params[:id])
      else  
        comment_error = true
      end
          @post_type = params[:post_type]
          @this_id = params[:id]     
        # Associate with comment or post
        if !comment_error && params[:problem_id] && @comment.save

          respond_to do |format|
            format.html { 
              flash[:notice] = "Comment Submitted Successfully" 
              redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
            }
            format.mobile { 
              flash[:notice] = "Comment Submitted Successfully" 
              redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
            }            
            format.js
          end
        else 
          # If save fails
          # Display errors  
          #@errors = e.record
          flash[:notice] = "Errors prevented the comment from saving"
          # Render the view again
          if params[:problem_id]
            @post = Post.find_by_id(params[:problem_id])
            @solutions = Solution.where(:post_id => params[:problem_id])
          else
            @post = Post.find_by_id(params[:id])
            @solutions = Solution.where(:post_id => params[:id])
          end
          @solution = Solution.new
          #format.html { render('posts/show') }
          render('posts/show')
        end
      #end
  end
  
end
