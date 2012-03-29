module ApplicationHelper
  
  def show_title?
    @page_title
  end
  
  def error_messages_for( object )
    render(:partial => 'shared/errors_to_display', :locals => {:object => object})    
  end
  
  def list_posts( posts )
    render(:partial => 'shared/list_posts', :locals => {:posts => posts})    
  end  
  
  def solution_count(post)
    return Solution.count(:conditions => ["post_id = ?", post.id])
  end
  
  def comment_count(post)
    comments = []
    
    post.comments.each do |comment|
        comments << comment
    end    
    
    solutions = post.solutions
    solutions.each do |solution|
      solution.comments.each do |comment|
        comments << comment
      end
    end

    return comments.count
  end
  
  def vote_count(post)
    votecount = 0
    post.votes(true)
    post.votes.each do |vote|
      if vote.vote_type.name == 'positive'
        votecount+=1
      elsif vote.vote_type.name == 'negative'
        votecount-=1
      end
    end
    return votecount
  end
  
  def is_logged_in
    session[:user_id] ? true : false
  end
  
  def is_admin
    is_logged_in && session[:role] == 2 ? true : false
  end
  
  def is_post_list_page
    params[:controller] == "posts" && params[:action] == "list" ? true : false
  end
  
  def get_comments(post)
    # Get comments for post
    if post.class == Post
        comments = Comment.where(["post_id = ?", post.id])
    elsif post.class == Solution
        comments = Comment.where(["solution_id = ?", post.id])
    else
        comments = nil
    end
    return comments
  end  
  
  def show_comments(post)
    # Get comments for post
    comments = get_comments(post)
    render(:partial => 'shared/list_comments', :locals => {:comments => comments})
  end
  
  def show_comment_form(post)
    if is_logged_in
      render(:partial => 'shared/comment_form', :locals => {:post => post, :post_type => post.class})
    end
  end
  
  def get_tag_occurences (tag)
    return PostTag.count(:conditions => ["tag_id = ?", tag.id])
  end  
  
end
