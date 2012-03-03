module ApplicationHelper
    
  def status_tag(boolean, options={})
    options[:true]        ||= ''
    options[:true_class]  ||= 'status true'
    options[:false]       ||= ''
    options[:false_class] ||= 'status false'

    if boolean
      content_tag(:span, options[:true], :class => options[:true_class])
    else
      content_tag(:span, options[:false], :class => options[:false_class])
    end
  end
  
  def error_messages_for( object )
    render(:partial => 'shared/errors_to_display', :locals => {:object => object})    
  end
  
  def is_logged_in
    if session[:user_id]
      return true
    else
      return false
    end
  end
  
  def is_admin
    if is_logged_in && session[:role] == 2
      return true
    else
      return false
    end
  end
  

end
