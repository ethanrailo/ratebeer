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
end
