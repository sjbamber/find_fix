class CategoriesController < ApplicationController
    
  before_filter :confirm_logged_in, :except => [:index, :list, :show]
  before_filter :confirm_admin_role, :except => [:index, :list, :show]
  before_filter :confirm_params_id, :only => [:show, :edit, :update, :delete, :destroy]
  
  # Render list as the default category view
  def index
    list
    render('list')
  end
  
  # list all categories sorted by their ancestry
  def list
    #get_category_list
    @categories_list = Category.sort_by_ancestry(Category.all).paginate(:page => params[:page], :per_page => 10)
  end
  
  # Sets up the show view to show a detailed category view
  def show
    @category = Category.find(params[:id])
    if @category.parent_id
      @parent = Category.find(@category.parent_id).name
    else
      @parent = "No Parent"
    end
  end
  
  # Sets up the new category view
  def new   
    @category = Category.new    # Instantiate new category to be added
    # Create a list of categories to appear in the parent category field including a no parent option
    @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
  end
  
  # Processes the data submitted from the new category form
  def create
    begin
      # Instantiate a new object using form parameters
      
      if params[:category]
        if params[:category][:parent_id].blank?
          @category = Category.new :name => params[:category][:name]
        else
          @category = Category.new :name => params[:category][:name], :parent_id => params[:category][:parent_id]
        end
      else
        @category = Category.new
      end  
      # Save the object
      @category.save!
      # If save succeeds, redirect to the list action
      flash[:notice] = "Category Created"
      redirect_to(:action => 'list')
    rescue ActiveRecord::RecordInvalid => e
      # If save fails, redisplay the form so user can fix categories
      @errors = e.record
      @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
      flash[:notice] = "Errors prevented the category from saving"
      render('new')
    end
    
  end
  
  # Sets up the edit category view
  def edit    
    @category = Category.find(params[:id])  # Find the category to be updated      
    # Create a list of categories to appear in the parent category field including a no parent option
    @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
  end
  
  # Processes the data submitted from the edit category form
  def update
    begin
      # Find object using form parameters
      @category = Category.find(params[:id])
      
      if @category.parent.blank? && params[:category][:parent_id].blank?
        @category.name = params[:category][:name]
      elsif @category.parent && params[:category][:parent_id].blank?
        @category.name = params[:category][:name]
        @category.ancestry.clear
        @category.parent_id = nil
      elsif @category.parent.blank? && params[:category][:parent_id]
        @category.name = params[:category][:name]
        @category.parent_id = params[:category][:parent_id]
      else 
        @category.name = params[:category][:name]
        @category.ancestry.clear
        @category.parent_id = nil
        @category.parent_id = params[:category][:parent_id]
      end 
      # Update the object
      @category.save!
      # If update succeeds, redirect to the show action
      flash[:notice] = "Category Updated"
      redirect_to(:action => 'show', :id => @category.id)
    rescue ActiveRecord::RecordInvalid => e
      # If update fails, redisplay the form so user can fix categories
      @errors = e.record
      @category_options = Category.all.unshift( Category.new( :name => "No Parent" ) )
      flash[:notice] = "Errors prevented the category from updating"
      render('edit')
    end   
  end
  
  # Sets up data for delete category view
  def delete
    @category = Category.find(params[:id])
  end
  
  # Permanently destroys a category with id given
  def destroy
    Category.find(params[:id]).destroy
    flash[:notice] = "Category Deleted"
    redirect_to(:action => 'list')
  end
  
end