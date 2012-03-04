class PostsController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:list, :show]
  before_filter :confirm_admin_role, :only => [:delete, :destroy]
  
  def index
    list
    render('list')
  end
  
  def list
    @posts = Post.order("posts.updated_at DESC")
  end
  
  def show
    @post = Post.find(params[:id])
    @error_messages = @post.error_messages
    @tags = @post.tags
    @categories = @post.categories
  end
  
  def new
    @post = Post.new

    2.times { @post.error_messages.build }
    2.times { @post.tags.build }
    3.times { @post.categories.build }

    # Create a list of categories to appear in the category
    @category_options = Category.all
    
  end
  
  def create
    # Instantiate new objects using data submitted from the form
    @post = Post.new(params[:post])
    @errors = []
    @tags = []
    @categories = []
    params[:post][:error_messages_attributes].each do |error| 
      @errors << ErrorMessage.new(error.last) unless error.last[:description].blank?
    end
    params[:post][:tags_attributes].each do |tag| 
      @tags << Tag.new(tag.last) unless tag.last[:name].blank?
    end    
    params[:post][:categories_attributes].each do |category|
      # Get the category object
      @categories << Category.find_by_name(category.last[:name]) unless category.last[:name].blank?
    end 
    # @category = Category.new(params[:post][:categories_attributes]["0"])
#         
    # # Get the category object from the submitted ID
    # @category = Category.find_by_name(@category.name) unless @category.name.blank?

    error_messages_updated = true
    tags_updated = true
   
    # Check if the error messages already exist in the database
    @errors.each_with_index do |error, i|
       # If the error message does not exist, save the record, else find the record
      if error_message_exists = ErrorMessage.find_by_description(error.description)
        @errors[i] = error_message_exists
      else
        error_messages_updated = error.save
      end
    end
    
    # Check if the tags already exist in the database
    @tags.each_with_index do |tag, i|
       # If the tag does not exist, save the record, else find the record
      if tag_exists = Tag.find_by_name(tag.name)
        @tags[i] = tag_exists
      else
        tags_updated = tag.save
      end
    end
    
    # Clear error tag and category attributes from the post object before saving
    @post.error_messages.clear
    @post.tags.clear
    @post.categories.clear
    
    # Associate the author of the post
    @post.user = User.find_by_id(session[:user_id]) if session[:user_id]
    
    if  error_messages_updated && tags_updated && @post.save
      # if saves are successful, make the required relationships
      @errors.each do |error|
        @post.error_messages << error
      end
      @categories.each do |category|
        @post.categories << category unless category.name.blank?
      end
      @tags.each do |tag|
        @post.tags << tag
      end
           
      # If save succeeds, redirect to the list action
      flash[:notice] = "Post Created"
      redirect_to(:action => 'list')
    else    
      # If save fails, redisplay the form so user can fix posts
      # Create a list of categories to appear in the category
      flash[:notice] = "Errors prevented the post from saving"
      @category_options = Category.all
      2.times { @post.error_messages.build }
      2.times { @post.tags.build }
      3.times { @post.categories.build }
      render('new')
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    
    2.times { @post.error_messages.build }
    2.times { @post.tags.build }
    3.times { @post.categories.build }    
    
    @category_options = Category.all
  end
  
  def update
     # Find object using form parameters
    @post = Post.find(params[:id])
     # Create a list of categories to appear in the category
    @category_options = Category.all
    # Update the object
    if @post.update_attributes(params[:post])
      # If update succeeds, redirect to the show action
      flash[:notice] = "Post Updated"
      redirect_to(:action => 'show', :id => @post.id)
    else
      # If update fails, redisplay the form so user can fix posts
      render('edit')
    end   
  end
  
  def delete
    @post = Post.find(params[:id])
  end
  
  def destroy
    Post.find(params[:id]).destroy
    flash[:notice] = "Post Deleted"
    redirect_to(:action => 'list')
  end
  
end
