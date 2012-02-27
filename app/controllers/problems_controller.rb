class ProblemsController < ApplicationController
  
  def index
    list
    render('list')
  end
  
  def list
    @problems = Problem.order("problems.id ASC")
  end
  
  def show
    @problem = Problem.find(params[:id])
  end
  
  def new
    @problem = Problem.new
  end
  
  def create
    # Instantiate a new object using form parameters
    @problem = Problem.new(params[:problem])
    # Save the object
    if @problem.save
      # If save succeeds, redirect to the list action
      flash[:notice] = "Problem Created"
      redirect_to(:action => 'list')
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end
  end
  
  def edit
    @problem = Problem.find(params[:id])
  end
  
  def update
     # Find object using form parameters
    @problem = Problem.find(params[:id])
    # Update the object
    if @problem.update_attributes(params[:problem])
      # If update succeeds, redirect to the show action
      flash[:notice] = "Problem Updated"
      redirect_to(:action => 'show', :id => @problem.id)
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end   
  end
  
  def delete
    @problem = Problem.find(params[:id])
  end
  
  def destroy
    Problem.find(params[:id]).destroy
    flash[:notice] = "Problem Deleted"
    redirect_to(:action => 'list')
  end
  
end
