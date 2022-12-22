class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{4,}\z/,
                                 message: "min length 4 chars. include at least one lowercase character, one uppercase character and one number" }
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_secure_password

  def to_s
    username
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings_by_style = ratings.group_by { |r| r.beer.style }
    ratings_by_style.map { |style, ratings| [style, ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.count] }.sort_by { |_style, average| average }.reverse[0][0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings_by_brewery = ratings.group_by { |r| r.beer.brewery }
    ratings_by_brewery.map { |brewery, ratings| [brewery, ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.count] }.sort_by { |_brewery, average| average }.reverse[0][0]
  end

  def self.top_raters(count)
    sorted_by_given_ratings_count = User.all.sort_by { |u| -u.ratings.count }
    sorted_by_given_ratings_count[0..(count - 1)]
  end
end
