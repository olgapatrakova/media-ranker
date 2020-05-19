require "test_helper"

describe VotesController do
  it "must get upvote" do
    get votes_upvote_url
    must_respond_with :success
  end

end
