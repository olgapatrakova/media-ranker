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

end
