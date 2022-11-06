class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    self.ratings.inject(0.0) { |sum, rating| sum + rating.score } / self.ratings.size
  end
end
