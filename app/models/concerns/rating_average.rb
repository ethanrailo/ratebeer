module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    average = ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.size
    average.round(2)
  end
end
