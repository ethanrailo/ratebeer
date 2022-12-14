require "rails_helper"

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("iso 3", from: "rating[beer_id]")
    fill_in("rating[score]", with: "15")

    expect {
      click_button "Create Rating"
    }.to change { Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is shown correctly on the list of ratings -page" do
    create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
    visit ratings_path
    expect(page).to have_content "Recent ratings"
    expect(page).to have_content "anonymous 10"
    expect(page).to have_content "Most active users"
    expect(page).to have_content "Pekka, 5 ratings"
  end
end
