class VotesController < ApplicationController
  before_filter :confirm_logged_in#, :except => [:index, :list, :show]
  #before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id#, :only => [:show, :edit, :update, :delete, :destroy]  
  
  def create
    @vote = Vote.new
    if params[:problem_id] &&  params[:vote_type] && params[:post_type]
      vote_exists = false
      vote_type = VoteType.find_by_name(params[:vote_type])
      @vote.vote_type = vote_type
      @vote.user_id = session[:user_id]
      if params[:post_type] == "Post"
        @vote.post_id = params[:id]
        vote_exists = true unless Vote.where("post_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
      elsif params[:post_type] == "Solution"
        @vote.solution_id = params[:id]
        vote_exists = true unless Vote.where("solution_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
      elsif params[:post_type] == "Comment"
        @vote.comment_id = params[:id]
        vote_exists = true unless Vote.where("comment_id=#{params[:id]} AND user_id=#{session[:user_id]}").blank?
      else
        @vote = Vote.new
      end
      if !vote_exists && @vote.save
        flash[:notice] = "Vote Successful"
        redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
      else  
        flash[:notice] = "Vote Failed"
        flash[:notice] += ". You have already voted on this #{params[:post_type].to_s.downcase!}" if vote_exists
        redirect_to(:controller => 'posts', :action => 'show', :id => params[:problem_id])
      end
    else
      flash[:notice] = "An error occured"
      redirect_to(:controller => 'public', :action => 'index')
    end
  end    
  
end
