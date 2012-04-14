class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded
    @recent_problems = Post.search_tank("__type:(Post)", :fetch => [:title, :updated_at, :username, :category_names, :tag_names, :solutions_size, :comments_size, :score], :page => params[:page], :function => 1)
  end
end
