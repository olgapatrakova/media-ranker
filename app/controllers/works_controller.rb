class WorksController < ApplicationController
  def index
    @works = Work.all.order("created_at") # maintains order 
  end

  def show
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      redirect_to works_path
      return
    end
  end

  def new
    @work = Work.new
  end

  def create # Set the availability status to true by default
    @work = Work.new

    if @work.save 
      redirect_to work_path(@work.id)
      return
    else 
      render :new, status: :not_found
      return
    end
  end

  def edit
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      redirect_to works_path
      return
    end
  end

  def update
    @work = Work.find_by(id: params[:id])
    if @work.nil?
      redirect_to works_path
      return
    elsif @work.update(work_params)
      redirect_to work_path(@work.id) 
      return
    else 
      render :edit, status: :not_found
      return
    end
  end

  def destroy
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      redirect_to works_path
      return
    else
      @work.destroy
      redirect_to works_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
