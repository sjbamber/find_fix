class PostsController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:list, :show]
  before_filter :confirm_admin_role, :only => [:delete, :destroy]
  
  def index
    list
    render('list')
  end
  
  def list
    @posts = Post.order("posts.id ASC")
  end
  
  def show
    @post = Post.find(params[:id])
    @error_messages = @post.error_messages
    @tags = @post.tags
    @categories = @post.categories
  end
  
  def new
    @post = Post.new
    @error_message = ErrorMessage.new
    @tag = Tag.new
    
    # Create a list of categories to appear in the category
    categories = Category.all.unshift( Category.new( :name => "--- Pick a Category ---" ) )
    @category_options = categories.collect {|c| [c.name, c.id]}
    
  end
  
  def create
    # Instantiate a new object using form parameters
    @post = Post.new(params[:post])
    @error_message = ErrorMessage.new(:description => params[:error_message]["description"])
    unless params[:category]["id"].empty?
      @category = Category.find(params[:category]["id"])
    else
      @category = Category.new
    end   
    @tag = Tag.new(:name => params[:tag]["name"])
    
    # Create a list of categories to appear in the category
    categories = Category.all.unshift( Category.new( :name => "--- Pick a Category ---" ) )
    @category_options = categories.collect {|c| [c.name, c.id]}
    
    # Save the object
    if @post.save && @error_message.save && @tag.save
       # If save succeeds, make the relevant relationships
      @post.error_messages << @error_message
      @post.categories << @category
      @post.tags << @tag
      # If save succeeds, redirect to the list action
      flash[:notice] = "Post Created"
      redirect_to(:action => 'list')
    else
      # If save fails, redisplay the form so user can fix posts
      render('new')
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    @error_message = ErrorMessage.new
    @tag = Tag.new
    
    # Create a list of categories to appear in the category
    @category_options = Category.all.collect {|c| [c.name, c.id]}
  end
  
  def update
     # Find object using form parameters
    @post = Post.find(params[:id])
     # Create a list of categories to appear in the category
    @category_options = Category.all.collect {|c| [c.name, c.id]}
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
