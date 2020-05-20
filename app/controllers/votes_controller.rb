class VotesController < ApplicationController
  def upvote
    if session[:user_id].nil?
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)
      return
    end
    
    work = Work.find_by(id: params[:work_id])
    @vote = Vote.new(work_id: params[:work_id], user_id: session[:user_id])
    saved = @vote.save
    if !saved
      flash[:error] = "A problem occurred: Could not upvote"
      flash[:validation_errors] = @vote.errors.to_hash(false)
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:success] = "Successfully upvoted!"
      redirect_back(fallback_location: root_path)
      return
    end
  end

  private

  def vote_params
    return params.require(:vote).permit(:work_id, :user_id)
  end
end
