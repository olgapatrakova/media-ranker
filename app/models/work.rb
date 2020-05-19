class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes
  validates :title, presence: true, uniqueness: true

  def self.find_top(category)
    category_records = self.where(category: category)
    # give 10
    return category_records.slice(0,10)
  end

  def self.all_categories
    categories = []
    self.all.each do |work|
      categories << work.category
    end
    return categories.uniq
  end
end
