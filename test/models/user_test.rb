require "test_helper"

describe User do
  before do
    @user = User.create(username: "Test")
  end

  it "can be instantiated" do
    # Arrange
    user = User.new(username: "Test")
    user.save
    # Assert
    expect(User.last).must_equal user
  end

  it "has the required fields" do
    # Arrange
    user = User.create(username: "Test")
    # Assert
    result = User.last
    expect(result.id).must_equal user.id
    expect(result.username).must_equal user.username
    expect(result.created_at).wont_be_nil
  end

  describe 'validations' do
    it "is valid when all fields are filled" do
      result = @user.valid?
      expect(result).must_equal true
    end

    it 'is valid when an existing username is entered' do
      existing_user = users(:grace)
      expect(existing_user.valid?).must_equal true
    end

    it 'fails validation when username is nil' do
      @user.username = nil
      expect(@user.valid?).must_equal false
      expect(@user.errors.messages.include?(:username)).must_equal true
      expect(@user.errors.messages[:username].include?("can't be blank")).must_equal true
    end
  end

  describe 'relations' do
    it "has 'votes' relationship" do
      vote = Vote.create(user_id: @user.id, work_id: works(:summer).id)
      expect(@user.votes.count).must_equal 1
      expect(@user.votes.first).must_equal vote
    end

    it 'permits a user to have many votes' do
      Vote.create(user_id: @user.id, work_id: works(:summer).id)
      expect(@user.votes.count).must_equal 1
      Vote.create(user_id: @user.id, work_id: works(:wakeup).id)
      expect(@user.votes.count).must_equal 2
    end

    it 'permits a user to have zero votes' do
      expect(@user.votes.count).must_equal 0
    end

    it "has works through votes" do
      Vote.create(user_id: @user.id, work_id: works(:summer).id)
      expect(@user.works).wont_be_nil
      expect(@user.works.count).must_equal 1
      expect(@user.works.first.id).must_equal works(:summer).id
    end
  end
end
