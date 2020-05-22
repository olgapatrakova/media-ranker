class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes
  validates :title, presence: true, uniqueness: true

  def self.split_and_sort(category)
    category_records = self.where(category: category)
    sorted_records = category_records.sort_by{ |record| record.votes.count }.reverse
    return sorted_records
  end

  def self.find_top(category)
    sorted = self.split_and_sort(category)
    if sorted.size > 10
      return sorted[0,10]
    else
      return sorted
    end
  end

  def self.is_spotlight
    # a simple way to find a spotlight that is huge in terms of time complexity
    # return Work.all.sort_by{ |record| record.votes.count }.first

    # join works and votes, take only those that present in both tables
    # group them to 1 table, count votes, return 1 with max value
    # gained help on that
    if Vote.count != 0
      spotlight_id = Work.joins(:votes).group("works.id").order("count_votes_id DESC").limit(1).count("votes.id").keys[0]
      return Work.find_by(id: spotlight_id)
    else
      return Work.first
    end
  end

  def self.all_categories
    categories = []
    self.all.each do |work|
      categories << work.category
    end
    return categories.uniq
  end
end
