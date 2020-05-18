require "test_helper"

describe UsersController do
  it "must get login_form" do
    get users_login_form_url
    must_respond_with :success
  end

  it "must get login" do
    get users_login_url
    must_respond_with :success
  end

  it "can login a new user" do
    user = nil
    expect{
      user = login()
    }.must_differ "User.count", 1

    must_respond_with :redirect
    expect(user).wont_be_nil
    expect(session[:user_id]).must_equal user.id
    expect(user.username).must_equal user_hash[:user][:username]
  end

  it "can login an existing user" do
    user = User.create(username: "Ed")

    expect{
      login(user.username)
    }.wont_change "User.count"
    expect(session[:user_id]).must_equal user.id
  end
end
