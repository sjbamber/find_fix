module ApplicationHelper
  
  # Has a page title been set?
  def show_title?
    @page_title
  end
  
  # Render a partial displaying a list of errors associated with an object (if any)
  def error_messages_for( object )
    render(:partial => 'shared/errors_to_display', :locals => {:object => object})    
  end
  
  # Return the number of solutions a post contains
  def solution_count(post)
    return Solution.count(:conditions => ["post_id = ?", post.id])
  end
  
  # Return the total number of comments a post and its solutions contain
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
  
  # Render a partial view to show the score of a post and the voting options
  def show_voting(post, problem_id)
      render(:partial => 'votes/vote', :locals => {:post => post, :problem_id => problem_id})
  end  
  
  # Return true if a user is logged in, else return false
  def is_logged_in
    session[:user_id] ? true : false
  end
  
  # Return true if a user is logged in and is an admin, else return false
  def is_admin
    is_logged_in && session[:role] == 2 ? true : false
  end
  
  # Return true if the url is posts/list, else return false
  def is_post_list_page
    params[:controller] == "posts" && params[:action] == "list" ? true : false
  end
  
  # Render a partial view to show the comment form
  def show_comment_form(post, problem_id)
    render(:partial => 'comments/form', :locals => {:post => post, :post_type => post.class, :problem_id => problem_id})
  end
  
  # Return the total number of times a tag is used in the application
  def get_tag_occurences (tag)
    return PostTag.count(:conditions => ["tag_id = ?", tag.id])
  end  
  
  # Return true if the supplied controller and action match the current controller and action
  def this_page_is(controller, action)
    if params[:controller] == controller && params[:action] == action
      return true
    else
      return false
    end
  end
  
  # Fetch tags and categories to show in sidebar
  def get_categories_for_right_bar
    @categories = Category.sort_by_ancestry(Category.paginate(:page => params[:page]).all)
  end
  
  def get_tags_for_right_bar
    @tags = Tag.order("(select count(*) from post_tags where tag_id = tags.id) DESC").limit(10)
  end  
  
end
