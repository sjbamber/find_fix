class CategoriesController < ApplicationController
    
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
         @parent << "none"
      end
    end
  end
  
  def show
    @category = Category.find(params[:id])
    if @category.parent_id
      @parent = Category.find(@category.parent_id).name
    else
      @parent = "none"
    end
  end
  
  def new
    @category = Category.new
    @categories = Category.order("categories.id ASC")
  end
  
  def create
    # Instantiate a new object using form parameters
    @category = Category.new(params[:category])
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
    @category = Category.find(params[:id])
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
