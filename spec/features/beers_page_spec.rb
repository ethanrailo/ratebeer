require "rails_helper"

include Helpers

describe "Beer" do
  before :each do
    @user = FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is created when the name is valid" do
    FactoryBot.create :brewery
    FactoryBot.create :style
    visit new_beer_path
    fill_in("beer[name]", with: "Kalex")
    select("lager", from: "beer_style_id")
    select("anonymous", from: "beer_brewery_id")
    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "is not created when the name is missing" do
    FactoryBot.create :brewery
    FactoryBot.create :style
    visit new_beer_path
    select("lager", from: "beer_style_id")
    select("anonymous", from: "beer_brewery_id")
    click_button "Create Beer"

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
