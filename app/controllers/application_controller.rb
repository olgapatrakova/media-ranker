class ApplicationController < ActionController::Base

before_action :require_login, only: [:upvote]

# will apply to all our controllers
  def current_user
    # use find_by method with data from session
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    if current_user.nil?
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)
    end
  end
end
