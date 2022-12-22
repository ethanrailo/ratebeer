class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  validates :name, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end

  def self.top(count)
    sorted_by_rating_in_desc_order = Beer.all.sort_by { |b| -b.average_rating }
    sorted_by_rating_in_desc_order[0..(count - 1)]
  end
end
