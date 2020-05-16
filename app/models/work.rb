class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  def self.find_top(category)
    category_records = self.where(category: category)
    # give 10
    return category_records.slice(0,10)
  end

  def self.all_categories
    # find distinct categories
    categories_find = self.select(:category).distinct # returns active records
    # create an array with categories
    categories = categories_find.map { |cat| cat.category }
    return categories
  end
end
