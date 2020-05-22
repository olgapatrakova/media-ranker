require "test_helper"

describe Vote do
  before do
    @user = users(:grace)
    @work = works(:summer)
  end

  it "can be instantiated" do
    # Arrange
    vote = Vote.new(work_id: @work.id, user_id: @user.id)
    # Act
    vote.save
    # Assert
    expect(Vote.last).must_equal vote
  end

  it "has the required fields" do
    # Arrange
    vote = Vote.create(work_id: @work.id, user_id: @user.id)
    # Assert
    expect(vote.user_id).must_equal @user.id
    expect(vote.work_id).must_equal @work.id
    expect(vote.created_at).wont_be_nil
  end

  describe 'validations' do
    it "is valid when all fields are filled and user_is is unique to work_id" do
      # Arrange 
      vote = Vote.create(work_id: @work.id, user_id: @user.id)
      # Act
      result = vote.valid?
      # Assert
      expect(result).must_equal true
    end

    it "fails validation when the work_id is not unique to user_id" do
      # Arrange 
      vote1 = Vote.create(work_id: @work.id, user_id: @user.id)
      # Act
      vote2 = Vote.create(work_id: @work.id, user_id: @user.id)
      # Assert
      expect(vote2.valid?).must_equal false
      expect(vote2.errors.messages.include?(:user)).must_equal true
      expect(vote2.errors.messages[:user].include?("has already voted for this work")).must_equal true
    end
  end

  describe "relations" do
    it "has a user" do
      vote = Vote.create(work_id: @work.id, user_id: @user.id)
      expect(vote.user).must_equal @user
    end 

    it "can set the user" do
      vote = Vote.new(user_id: "1", work_id: "2")
      vote.user = users(:grace)
      expect(vote.user_id).must_equal users(:grace).id
    end

    it "has a work" do
      vote = Vote.create(work_id: @work.id, user_id: @user.id)
      expect(vote.work).must_equal works(:summer)
    end 

    it "can set the work" do
      vote = Vote.create(user_id: "1", work_id: "2")
      vote.work = works(:summer)
      expect(vote.work_id).must_equal works(:summer).id
    end
  end
end
