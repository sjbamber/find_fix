class PostsController < ApplicationController
  # include Tanker module to handle search function
  include Tanker
  
  # Before Filters to manage access to controller actions
  before_filter :confirm_logged_in, :except => [:index, :list, :show, :search]
  before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id, :only => [:show, :edit, :update, :delete, :destroy]
  
  # Set tag name as a field containing jQuery autocomplete, populated by activerecord
  autocomplete :error_message, :description, :full => true
  autocomplete :tag, :name, :full => true
  
  # Renders the list view as the default post view
  def index
    list
    render('list')
  end
  
  # Performs the search by processing the query received in GET and using it in the 'search_tank' method to retrieve matching posts
  def search
    if params[:query] && !params[:query].blank? # Check a query has been sent
      q = params[:query].split.join(" ") # Set the query to a variable and remove leading and trailing whitespace between words
      q = q.sub( " ", "* " ) # Add * after each word to make it a wildcard search
      
      # Define search string that queries only listed attributes of the index and weights them accordingly using ^(weight)
      search_string = "title:(#{q}*) OR description:(#{q}*) OR error_message_descriptions:(#{q}*)"\
      " OR category_names:(#{q}*) OR tag_names:(#{q}*)"\
      " OR solution_descriptions:(#{q}*) OR post_comments:(#{q}*) OR solutions_comments:(#{q}*)"
      fetch = [:title, :updated_at, :username, :category_names, :tag_names, :solutions_size, :comments_size, :score]
      if params[:cfacet] && !params[:tfacet]
        @posts = post_query(q, fetch, true, {'category' => params[:cfacet].to_s})
      elsif params[:tfacet] && !params[:cfacet]
        @posts = post_query(q, fetch, true, {'tag' => params[:tfacet].to_s})
      elsif params[:cfacet] && params[:tfacet]
        @posts = post_query(q, fetch, true, {'category' => params[:cfacet].to_s, 'tag' => params[:tfacet].to_s})
      else
        @posts = post_query(q, fetch, true)
      end  
      @posts.blank? ? @category_facets = {} : @category_facets = get_facets(@posts, "category")
      @posts.blank? ? @tag_facets = {} : @tag_facets = get_facets(@posts, "tag")
      @content_header = "Search Results for query: #{params[:query].strip}"
    else
      @content_header = "Search Results for query: "
      @posts = [].paginate(:page => params[:page])
    end  
    render('list')
  end
  
  # lists all posts
  def list
    fetch = [:title, :updated_at, :username, :category_names, :tag_names, :solutions_size, :comments_size, :score]
    case
    
    when params[:category_name] && !params[:category_name].blank? 
      # Search on the category specified and any child categories if there are any.
      category = Category.find_by_name(params[:category_name])
      search_categories = category.name.to_s
      children = category.children
      unless children.blank?
        children.each do |child|
          search_categories += " OR #{child.name}"
        end
      end
      @content_header = "Problems for Category: #{category.name.to_s}"
      @posts = Post.search_tank("category_names:(#{search_categories}*)", :fetch => fetch, :page => params[:page], :function => 1)
       
    when params[:tag_name] && !params[:tag_name].blank?
      @content_header = "Problems for Tag: #{params[:tag_name].strip}"
      @posts = Post.search_tank("tag_names:(#{params[:tag_name].strip}*)", :fetch => fetch, :page => params[:page], :function => 1)
      
    else
      @posts = Post.search_tank("__type:(Post)", :fetch => fetch, :page => params[:page], :function => 1)
      @content_header = "All Problems"
    end
  end
  
  # Sets up the show view to show a detailed post view
  def show
    @post = Post.find_by_id(params[:id])
    if @post == nil
      flash[:notice] = "Cannot find requested post. It may have been removed."
      redirect_to(:action => 'list')
    else
      @solutions = @post.solutions
      @solutions.each do |sol|
        sol.score = sol.get_score
      end
      @solutions = @solutions.sort_by{|s| s.score}.reverse     
      @solution = Solution.new
      @comment = Comment.new
      @vote = Vote.new
    end
  end 
  
  # Sets up the new post view for creating a new problem
  def new
    
    @post = Post.new
    # Create a list of categories to appear in the category drop down
    @category_options = Category.sort_by_ancestry(Category.all)
    @post.error_messages.build
    @post.categories.build
    @post.tags.build      
  end
  
  # Processes the data submitted from the new problem form
  def create
    begin
      # Create a new post object from the form data
      @post = Post.new(params[:post])
      @post.description = clean_editor_input(@post.description) #process description being entered from custom textarea
      # Associate the author of the post
      @post.user = User.find_by_id(session[:user_id]) if session[:user_id]     
      # Check the errors, categories and tags do not already exist and update the object if they do
      @post.error_messages.each_with_index do |error_message, i|
        @post.error_messages[i] = ErrorMessage.find_or_initialize_by_description(error_message.description)
      end
      @post.categories.each_with_index do |category, i|
        @post.categories[i] = Category.find_or_initialize_by_name(category.name)
      end      
      @post.tags.each_with_index do |tag, i|
        @post.tags[i] = Tag.find_or_initialize_by_name(tag.name)
        @post.tags[i].owners << @post.user
      end
      # Ensure nested attributes get validated
      @post.validate_nested = true
      # Commit the post to the database
      @post.save!

      flash[:notice] = "Post Created"
      redirect_to(:action => 'show', :id => @post.id)
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      flash[:notice] = "Errors prevented the post from saving"
      # Clear any found ids to prevent the form raising errors
      @post.error_messages.each_with_index do |error_message, i|; @post.error_messages[i].id = nil; end
      @post.categories.each_with_index do |category, i|; @post.categories[i].id = nil; end
      @post.tags.each_with_index do |tag, i|; @post.tags[i].id = nil; end
      @post.error_messages.build if @post.error_messages.blank?
      @post.categories.build if @post.categories.blank?
      @post.tags.build if @post.tags.blank?
      # Render the view again
      @category_options = Category.all
      render('new')
    end
  end
  
  # Sets up the edit post view
  def edit
    @post = Post.find_by_id(params[:id])
    @category_options = Category.all
  end
  
  # Processes the data submitted from the edit problem form
  def update
    begin
      # Create a new post object from the form data
      @post = Post.find_by_id(params[:id])
      @post.title = params[:post][:title]
      @post.description = params[:post][:description]
      # Check the errors and tags do not already exist and update the object if they do
      @post.error_messages.clear
      params[:post][:error_messages_attributes].each_with_index do |error_message, i|
        @post.error_messages << ErrorMessage.find_or_initialize_by_description(error_message.last["description"])
      end
      @post.categories.clear
      params[:post][:categories_attributes].each_with_index do |category, i|
        @post.categories << Category.find_or_initialize_by_name(category.last["name"])
      end
      @post.tags.clear
      params[:post][:tags_attributes].each_with_index do |tag, i|
        @post.tags << Tag.find_or_initialize_by_name(tag.last["name"])
      end
      # Update the post
      @post.save!

      flash[:notice] = "Post Updated"
      redirect_to(:action => 'show', :id => params[:id])
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      flash[:notice] = "Errors prevented the post from saving"
      # Render the view again
      @category_options = Category.all
      render('edit')
    end    
  end
  
  # Sets up data for delete post view
  def delete
    @post = Post.find(params[:id])
  end
  
  # Permanently destroys a post with id given
  def destroy
    pe = PostErrorMessage.find_by_post_id(params[:id])
    pe.destroy if pe
    pc = PostCategory.find_by_post_id(params[:id])
    pc.destroy if pc
    pt = PostTag.find_by_post_id(params[:id])
    pt.destroy if pt
    Post.find(params[:id]).destroy
    flash[:notice] = "Post Deleted"
    redirect_to(:action => 'list')
  end
  
  private
  
  def post_query(query, fetch, snippet=false, facet=false, function=0)
    if snippet && facet
        posts = Post.search_tank( "#{query}*", :snippets => [:description, :error_message_descriptions, :solution_descriptions, :post_comments, :solutions_comments],\
        :fetch => fetch, :page => params[:page],  :function => function, :category_filters => facet)
    elsif snippet && !facet
        posts = Post.search_tank( "#{query}*", :snippets => [:description, :error_message_descriptions, :solution_descriptions, :post_comments, :solutions_comments],\
        :fetch => fetch, :page => params[:page],  :function => function)
    elsif !snippet && facet
        posts = Post.search_tank( "#{query}*", :fetch => fetch, :page => params[:page],  :function => function, :category_filters => facet)
    else
        posts = Post.search_tank( "#{query}*", :fetch => fetch, :page => params[:page],  :function => function)
    end
    return posts
  end
  
end
