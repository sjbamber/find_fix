module PostsHelper
  
  def show_score(post, problem_id)
      render(:partial => 'score', :locals => {:post => post, :problem_id => problem_id})
  end  
  
  def get_tiptext(post)
    tiptext = { 'positive' => "", 'negative' => "" }
    if post.class == Post
      tiptext['positive'] = 'This problem description is useful. It is clear and well investigated'
      tiptext['negative'] = 'This problem description is poor. It is unclear and lacks proper investigation'
    elsif post.class == Solution
      tiptext['positive'] = 'This solution was helpful. It is clear, well investigated and safe to use.'
      tiptext['negative'] = 'This solution was not helpful. It is misleading and/or does not work.'      
    elsif post.class == Comment
      tiptext['positive'] = 'This comment was helpful.'
      tiptext['negative'] = 'This comment was not helpful or not relevant.'  
    end
    return tiptext
  end
  
end
