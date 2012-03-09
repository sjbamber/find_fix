class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded 
    
    get_category_list # Method in application controller, Gets a structured list of categories
    get_tag_list # Method in application controller, Gets a list of tags
    @recent_problems = Post.order("posts.updated_at DESC").limit(10).where("post_type=0")

  end
end
