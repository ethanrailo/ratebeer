class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    sum = 0.0
    self.ratings.each do |rating|
      sum += rating.score
    end
    (sum / self.ratings.count).to_f
  end
end
