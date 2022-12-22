class Style < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.top(count)
    sorted_by_rating_in_desc_order = Style.all.sort_by { |s| -s.average_rating }
    sorted_by_rating_in_desc_order[0..(count - 1)]
  end
end
