require "test_helper"

describe VotesController do
  it "must upvote" do
    # Arrange
    user  = login()
    work = works(:summer)
    # Act, assert
    expect {
      post work_upvote_url(work.id)
    }.must_change "Vote.count", 1
    expect(Vote.last.user_id).must_equal user.id
    expect(Vote.last.work_id).must_equal work.id
    expect(flash[:success]).must_equal "Successfully upvoted!" 
    must_respond_with :redirect
  end

  it "must redirect and show error message if there is no logged in user" do
    # Arrange
    work = works(:summer)
    # Act, assert
    expect {
      post work_upvote_url(work.id)
    }.wont_change "Vote.count"
    expect(flash[:error]).must_equal "A problem occurred: You must log in to do that" 
    must_respond_with :redirect
  end

  it "must not let upvote for the second time" do
    # Arrange
    login()
    work = works(:summer)
    # Act, assert
    expect {
      post work_upvote_url(work.id)
    }.must_change "Vote.count", 1
    expect {
      post work_upvote_url(work.id)
    }.wont_change "Vote.count"
    expect(flash[:error]).must_equal "A problem occurred: Could not upvote" 
    expect(flash[:validation_errors][:user][0]).must_equal "has already voted for this work" 
    must_respond_with :redirect
  end
end
