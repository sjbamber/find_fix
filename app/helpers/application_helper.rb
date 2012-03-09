module ApplicationHelper
  
  def error_messages_for( object )
    render(:partial => 'shared/errors_to_display', :locals => {:object => object})    
  end
  
  def list_posts( posts )
    render(:partial => 'shared/list_posts', :locals => {:posts => posts})    
  end  
  
  def solution_count(post)
    return Post.count(:conditions => ["parent_id = ?", post.id])
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

end
