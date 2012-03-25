class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded 
    @categories = Category.sort_by_ancestry(Category.paginate(:page => params[:page]).all)
    @tags = Tag.order("(select count(*) from post_tags where tag_id = tags.id) DESC").limit(10)
    @recent_problems = Post.order("posts.updated_at DESC").limit(10)

  end
end
