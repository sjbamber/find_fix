class CategoriesController < ApplicationController
    
  before_filter :confirm_logged_in, :except => [:list, :show]
  before_filter :confirm_admin_role, :except => [:list, :show]
  
  def index
    list
    render('list')
  end
  
  def list
    #get_category_list
    @categories = Category.sort_by_ancestry(Category.all).paginate(:page => params[:page])
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
    @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
  end
  
  def create
    # Instantiate a new object using form parameters
    @category = Category.new

    if params[:category][:parent_id].blank?
      @category = Category.new :name => params[:category][:name]
    else
      @category = Category.new :name => params[:category][:name], :parent_id => params[:category][:parent_id]
    end    

    # Save the object
    if @category.save
      # If save succeeds, redirect to the list action
      flash[:notice] = "Category Created"
      redirect_to(:action => 'list')
    else
      # If save fails, redisplay the form so user can fix categories
      @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
      render('new')
    end
    
  end
  
  def edit    
    @category = Category.find(params[:id])  # Find the category to be updated      
    # Create a list of categories to appear in the parent category field including a no parent option
    @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
  end
  
  def update
    # Find object using form parameters
    @category = Category.find(params[:id])
    
    if @category.parent.blank? && params[:category][:parent_id].blank?
      @category.name = params[:category][:name]
    elsif params[:category][:parent_id].blank?
      @category.name = params[:category][:name]
      @category.ancestry.clear
    elsif @category.parent.blank?
      @category.name = params[:category][:name]
      @category.parent_id = params[:category][:parent_id]
    else 
      @category.name = params[:category][:name]
      @category.ancestry.clear
      @category.parent_id = params[:category][:parent_id]
    end 
    # Update the object
    if @category.save
      # If update succeeds, redirect to the show action
      flash[:notice] = "Category Updated #{params[:category][:parent]}"
      redirect_to(:action => 'show', :id => @category.id)
    else
      # If update fails, redisplay the form so user can fix categories
      @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
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