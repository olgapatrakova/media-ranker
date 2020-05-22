require "test_helper"

describe UsersController do
  describe "User login" do
    it "must get login_form" do
      get users_login_form_url
      must_respond_with :redirect
    end

    it "must get login" do
      get login_path
      must_respond_with :success
    end

    it "can login a new user" do
      user = nil
      user = User.new(username: "Test test")

      expect{
        user = login(user.username)
      }.must_change "User.count", 1
      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal "Test test"
    end

    it "can login an existing user" do
      user = User.create(username: "Ed")

      expect{
        login(user.username)
      }.wont_change "User.count"
      expect(session[:user_id]).must_equal user.id
    end
  end
  
  describe "logout" do
    it "can logout a logged in user" do
      # Arrange
      login()
      expect(session[:user_id]).wont_be_nil

      # Act
      post logout_path

      expect(session[:user_id]).must_be_nil
    end
  end

  describe "current user" do
    it "can return the page if the user is logged in" do
      # Arrange
      login()

      # Act
      get current_user_path

      # Assert
      must_respond_with :redirect
    end

    it "redirects us back if the user is not logged in" do
      # Act
      get current_user_path

      # Assert
      must_respond_with :redirect
    end
  end
end
