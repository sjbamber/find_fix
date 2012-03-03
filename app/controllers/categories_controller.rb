class CategoriesController < ApplicationController
    
  before_filter :confirm_logged_in, :except => [:list, :show]
  before_filter :confirm_admin_role, :except => [:list, :show]
  
  def index
    list
    render('list')
  end
  
  def list
    @categories = Category.order("categories.id ASC")
    @parent = []
    @categories.each do |category|
      if category.parent_id
         @parent << Category.find(category.parent_id).name
      else
         @parent << "No Parent"
      end
    end
  end
  
  def show
    @category = Category.find(params[:id])
    if @category.parent_id
      @parent = Category.find(@category.parent_id).name
    else
      @parent = "No Parent"
    end
  end
  
  def new
    
    @category = Category.new    # Instantiate new category to be added
      
    # Create a list of categories to appear in the parent category field including a no parent option
    categories = Category.all.unshift( Category.new( :name => "No Parent" ) )
    @options = categories.collect {|c| [c.name, c.id]}
    
  end
  
  def create
    # Instantiate a new object using form parameters
    @category = Category.new(params[:category])
    # Create a list of categories to appear in the parent category field including a no parent option
    categories = Category.all.unshift( Category.new( :name => "No Parent" ) )
    @options = categories.collect {|c| [c.name, c.id]}
    
    # Save the object
    if @category.save
      # If save succeeds, redirect to the list action
      flash[:notice] = "Category Created"
      redirect_to(:action => 'list')
    else
      # If save fails, redisplay the form so user can fix categories
      render('new')
    end
  end
  
  def edit
    
    @category = Category.find(params[:id])  # Find the category to be updated
      
    # Create a list of categories to appear in the parent category field including a no parent option
    categories = Category.all.unshift( Category.new(:id => nil, :name => "No Parent") )
    @options = categories.collect {|c| [c.name, c.id]}
    
  end
  
  def update
    # Find object using form parameters
    @category = Category.find(params[:id])
    # Update the object
    if @category.update_attributes(params[:category])
      # If update succeeds, redirect to the show action
      flash[:notice] = "Category Updated"
      redirect_to(:action => 'show', :id => @category.id)
    else
      # If update fails, redisplay the form so user can fix categories
      render('edit')
    end   
  end
  
  def delete
    @category = Category.find(params[:id])
  end
  
  def destroy
    Category.find(params[:id]).destroy
    flash[:notice] = "Category Deleted"
    redirect_to(:action => 'list')
  end
  
end
