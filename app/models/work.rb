class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: true

end
