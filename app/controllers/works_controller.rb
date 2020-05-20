class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]
  def index
    @works = Work.all.order("created_at") # maintains order 
  end

  def show
    if @work.nil?
      redirect_to works_path
      return
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save 
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:error] = "A problem occurred: Could not create #{@work.category}"
      render :new, status: :not_found
      return
    end
  end

  def edit
    if @work.nil?
      redirect_to works_path
      return
    end
  end

  def update
    if @work.nil?
      flash[:error] = "You need to choose media first"
      redirect_to works_path
      return
    elsif @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id) 
      return
    else 
      flash[:error] = "Unable to update"
      render :edit, status: :not_found
      return
    end
  end

  def destroy
    if @work.nil?
      flash.now[:error] = "A problem occurred: Could not destroy #{@work.category} #{@work.id}"
      redirect_to works_path
      return
    else
      flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
      @work.destroy
      redirect_to root_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end
end
