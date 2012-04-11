class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded
    @recent_problems = Post.order("posts.updated_at DESC").limit(15)
  end
end
