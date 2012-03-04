class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded 
    get_category_list
  end
end
