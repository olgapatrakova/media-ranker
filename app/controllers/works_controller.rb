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
end
