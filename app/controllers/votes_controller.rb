class VotesController < ApplicationController
  before_filter :confirm_logged_in#, :except => [:index, :list, :show]
  #before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id#, :only => [:show, :edit, :update, :delete, :destroy]  
  
  def create
    @vote = Vote.new
    if params[:problem_id] &&  params[:vote_type] && params[:post_type]
      vote_exists = false
      author_vote = false
      @post_type = params[:post_type].to_s.downcase
      @post_id = params[:id]
      
      votetype = VoteType.find_by_name(params[:vote_type])
      @vote.vote_type = votetype
      @vote.user_id = session[:user_id]
      if params[:post_type] == "Post"
        @vote.post = Post.find_by_id(params[:id])
        @vote_object = @vote.post
        vote_exists = true unless Vote.where("post_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
        author_vote = true if @vote.user_id == @vote.post.user_id
      elsif params[:post_type] == "Solution"
        @vote.solution = Solution.find_by_id(params[:id])
        @vote_object = @vote.solution
        vote_exists = true unless Vote.where("solution_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
        author_vote = true if @vote.user_id == @vote.solution.user_id
      elsif params[:post_type] == "Comment"
        @vote.comment = Comment.find_by_id(params[:id])
        @vote_object = @vote.comment
        vote_exists = true unless Vote.where("comment_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
        author_vote = true if @vote.user_id == @vote.comment.user_id
      else
        @vote = Vote.new
      end
      if !vote_exists && !author_vote && @vote.save
        respond_to do |format|
          format.html { 
            flash[:notice] = "Vote Successful"
            redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
          }
          format.js {
            @vote_failed = false
            @notice = "Vote Successful"           
          }
        end
      else  
        respond_to do |format|
          format.html { 
            flash[:notice] = "Vote Failed"
            flash[:notice] += ". You have already voted on this #{@post_type}" if vote_exists
            flash[:notice] += ". You cannot vote on a #{@post_type} that you created." if author_vote
            redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
          }
          format.js {
            @vote_failed = true
            @notice = "Vote Failed"
            @notice += ". You have already voted on this #{@post_type}" if vote_exists
            @notice += ". You cannot vote on a #{@post_type} that you created." if author_vote
          }
        end
      end
    else
      flash[:notice] = "An error occured"
      redirect_to(:controller => 'public', :action => 'index')
    end
  end    
  
end
