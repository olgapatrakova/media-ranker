class UsersController < ApplicationController
  def index
    @users = User.all.order("created_at")
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      redirect_to users_path
      return
    end
  end

  def login_form
    @user = User.new
  end

  def login
    user = User.find_by(username: params[:user][:username])
    p "user controller user #{user}"
    if user.nil?
      # New User
      
      user = User.new(username: params[:user][:username])
      p "user controller new user #{user}"
      if ! user.save
        p "not saved"
        flash[:error] = "A problem occurred: Could not log in"
        flash[:validation_errors] = user.errors.to_hash(false)
        redirect_to root_path
        return
      end
      flash[:success] = "Successfully created new user #{user.username} with ID #{user.id}"
    else
      # Existing User
      flash[:success] = "Successfully logged in as existing user #{user.username}"
    end

    session[:user_id] = user.id
    session[:username] = user.username
    p "session #{session.to_hash}"

    redirect_to root_path
  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user
        session[:user_id] = nil
        flash[:success] = "Successfully logged out"
      else
        session[:user_id] = nil
        flash[:error] = "Error Unknown User"
      end
    else
      flash[:error] = "You must be logged in to logout"
    end
    redirect_to root_path
  end

  def current
    if @current_user.nil?
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
      return
    end
  end
end
