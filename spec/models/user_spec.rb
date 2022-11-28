require "rails_helper"

RSpec.describe User, type: :model do
  include Helpers
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved with too short password" do
    user = User.create username: "Pekka", password: "Se1", password_confirmation: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password that only contains letters" do
    user = User.create username: "Pekka", password: "Secret", password_confirmation: "Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer, style: "Indian Pale Ale")
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average if several rated" do
      beer1 = FactoryBot.create(:beer, style: "Indian Pale Ale")
      beer2 = FactoryBot.create(:beer, style: "Indian Pale Ale")
      beer3 = FactoryBot.create(:beer, style: "Lager")
      beer4 = FactoryBot.create(:beer, style: "Lager")
      rating1 = FactoryBot.create(:rating, score: 50, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 1, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 30, beer: beer3, user: user)
      rating4 = FactoryBot.create(:rating, score: 40, beer: beer4, user: user)
      expect(user.favorite_style).to eq("Lager")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest average if several rated" do
      worst = FactoryBot.create(:brewery, name: "Huono")
      best = FactoryBot.create(:brewery, name: "Paras")
      beer1 = FactoryBot.create(:beer, brewery: worst)
      beer2 = FactoryBot.create(:beer, brewery: worst)
      beer3 = FactoryBot.create(:beer, brewery: best)
      beer4 = FactoryBot.create(:beer, brewery: best)
      rating1 = FactoryBot.create(:rating, score: 50, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 1, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 30, beer: beer3, user: user)
      rating4 = FactoryBot.create(:rating, score: 40, beer: beer4, user: user)
      expect(user.favorite_brewery).to eq(best)
    end
  end
end
