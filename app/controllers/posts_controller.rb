class PostsController < ApplicationController
  
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
  end
  
  def create
    # Instantiate a new object using form parameters
    @post = Post.new(params[:post])
    @error_message = ErrorMessage.new(:description => params[:error_message]["description"])
    @category = Category.find(params[:category]["id"])
    @tag = Tag.new(:name => params[:tag]["name"])
    # Save the object
    if @post.save && @error_message.save && @tag.save
       # If save succeeds, make the relevant relationships
      @post.error_messages << @error_message
      @category.posts << @post
      @tag.posts << @post
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
  end
  
  def update
     # Find object using form parameters
    @post = Post.find(params[:id])
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
