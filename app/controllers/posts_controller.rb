class PostsController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:index, :list, :show]
  before_filter :confirm_admin_role, :only => [:edit, :update, :delete, :destroy]
  before_filter :confirm_params_id, :only => [:show, :create_solution, :edit, :update, :delete]
  before_filter :confirm_not_solution, :only => [:show]
  
  def index
    list
    render('list')
  end
  
  def list
    case
    when params[:query] # Search function
      #@posts = Post.order("posts.updated_at DESC").where( ["title OR description LIKE ?", "%#{params[:query]}%"] )
      @posts = Post.order("posts.updated_at DESC").where( ["description LIKE ? OR title LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%"] ) # Query works with postgres     
      @posts.each_with_index do |post, i|
        if post.post_type == 1
          parent_post = Post.find_by_id(post.parent_id)
          if @posts.include?(parent_post)
            @posts[i] = nil
          else
            @posts[i] = parent_post
          end       
        end
      end
      @posts = @posts.compact
      @posts = @posts.paginate(:page => params[:page])
      
    when params[:category_id]
      category = Category.find_by_id(params[:category_id])
      if category.blank? 
        @posts = [].paginate(:page => params[:page])
      else  
        @posts = category.posts.paginate(:page => params[:page])
      end
      
    when params[:tag_id]
      tag = Tag.find_by_id(params[:tag_id])
      if tag.blank? 
        @posts = [].paginate(:page => params[:page])
      else  
        @posts = tag.posts.paginate(:page => params[:page])
      end
      
    else
      # @posts = Post.order("posts.updated_at DESC").where(:post_type => 0)
      @posts = Post.paginate(:page => params[:page]).order("posts.updated_at DESC").where(:post_type => 0)
    end
  end
  
  def show

    @post = Post.find_by_id(params[:id])
    @solutions = Post.where(:parent_id => params[:id])
    @solution = Post.new
    
  end
  
  def create_solution
    begin   
      @solution = Post.new(:parent_id => params[:id].to_i, :title => "Solution to Post ID #{params[:id]}", :description => params[:post][:description])
      @solution.post_type = 1
      @solution.user = User.find_by_id(session[:user_id]) unless session[:user_id].blank?
      @solution.save!
      flash[:notice] = "Solution Created"
      redirect_to(:action => 'show', :id => params[:id])
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      flash[:notice] = "Errors prevented the solution from saving"
      # Render the view again
      @post = Post.find_by_id(params[:id])
      @solutions = Post.where(:parent_id => params[:id])
      render('show')
    end
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
      redirect_to(:action => 'list')
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
      redirect_to(:action => 'show', :id => params[:id], :post_type => 0)
    rescue ActiveRecord::RecordInvalid => e
      # If save fails
      # Display errors
      @errors = e.record
      flash[:notice] = "Errors prevented the post from saving #{params}"
      # Render the view again
      @category_options = Category.all
      render('new')
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
  
  private
  
  # Before filters
  # Checks that a post being viewed is not a solution
  def confirm_not_solution
    thispost = Post.find_by_id(params[:id])
    if thispost.post_type && thispost.post_type == 0
      return true
    else
      redirect_to(:action => 'show', :id => thispost.parent_id )
      return false
    end 
  end
  
end
