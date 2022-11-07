module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    self.ratings.inject(0.0) { |sum, rating| sum + rating.score } / self.ratings.size
  end
end
