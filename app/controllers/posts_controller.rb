class PostsController < ApplicationController
  include Tanker
  
  before_filter :confirm_logged_in, :except => [:index, :list, :show, :search]
  before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id, :only => [:show, :edit, :update, :delete, :destroy]
  
  def index
    list
    render('list')
  end
  
  def search
    if params[:query] && !params[:query].blank? # Check a query has been sent
      q = params[:query].split.join(" ") # Set the query to a variable and remove leading and trailing whitespace between words
      q = q.sub( " ", "* " ) # Add wildcard characters after each word
      
      # Define search string that queries only listed attributes of the index and weights them accordingly using ^(weight)
      search_string = "title:(#{q}*) OR description:(#{q}*) OR error_message_descriptions:(#{q}*)"\
                      " OR category_names:(#{q}*) OR tag_names:(#{q}*)"\
                      " OR solution_descriptions:(#{q}*) OR post_comments:(#{q}*) OR solutions_comments:(#{q}*)"
                      
      @posts = Post.search_tank( "#{q}*", :snippets => [:description, :error_message_descriptions, :solution_descriptions, :post_comments, :solutions_comments],\
                                  :fetch => [:title, :updated_at, :user_id], :page => params[:page], :function => 0)
      @content_header = "Search Results for query: #{params[:query].strip}"
    else
      @content_header = "Search Results for query: "
      @posts = [].paginate(:page => params[:page])
    end
    render('list')
  end
  
  def list
    case
    
    when params[:category_id] && !params[:category_id].blank? 
      # Search on the category specified and any child categories if there are any.
      category = Category.find_by_id(params[:category_id])
      search_categories = category.name.to_s
      children = category.children
      unless children.blank?
        children.each do |child|
          search_categories += " OR #{child.name}"
        end
      end
      @content_header = "Problems for Category: #{category.name.to_s}"
      @posts = Post.search_tank("category_names:(#{search_categories}*)", :page => params[:page], :function => 1)
       
    when params[:tag_name] && !params[:tag_name].blank?
      @content_header = "Problems for Tag: #{params[:tag_name].strip}"
      @posts = Post.search_tank("tag_names:(#{params[:tag_name].strip}*)", :page => params[:page], :function => 1)
      
    else
      @posts = Post.paginate(:page => params[:page]).order("posts.updated_at DESC")
      @content_header = "All Problems"
    end
  end
  
  def show

    @post = Post.find_by_id(params[:id])
    @solutions = @post.solutions
    @solution = Solution.new
    @comment = Comment.new
    @vote = Vote.new

  end 
  
  def new
    
    @post = Post.new
    # Create a list of categories to appear in the category
    @category_options = Category.all
    
  end
  
  def create
    begin
      # Create a new post object from the form data
      @post = Post.new(params[:post])
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
      # Render the view again
      @category_options = Category.all
      render('new')
    end
  end
  
  def edit
    @post = Post.find_by_id(params[:id])
    @category_options = Category.all
  end
  
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
  
  def delete
    @post = Post.find(params[:id])
  end
  
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
  
end
