class User < ApplicationRecord
  has_many :votes
  has_many :works, through: :votes
  validates :username, presence: true
  # A problem occurred: Could not log in
  # username: can't be blank
end
