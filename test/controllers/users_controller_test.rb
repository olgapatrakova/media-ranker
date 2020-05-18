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

end
