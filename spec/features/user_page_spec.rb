require "rails_helper"

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content "Welcome back!"
      expect(page).to have_content "Pekka"
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "Username and/or password mismatch"
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in("user_username", with: "Brian")
    fill_in("user_password", with: "Secret55")
    fill_in("user_password_confirmation", with: "Secret55")

    expect {
      click_button("Create User")
    }.to change { User.count }.by(1)
  end

  describe "when given ratings" do
    before :each do
      create_beers_with_many_ratings({ user: @user }, 10, 20, 15, 7, 9)
    end

    it "only the users own ratings are shown in the user-specific page" do
      user2 = FactoryBot.create(:user, username: "Seppo")
      create_beers_with_many_ratings({ user: user2 }, 2, 5, 49)
      visit user_path(@user)
      expect(page).to have_content "Has made 5 ratings"
      expect(page).to have_content "anonymous 10"
    end

    it "deleting her own rating removes it from the database" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      expect(page).to have_content "anonymous 10 Delete"
      expect(@user.ratings.count).to eq(5)
      page.all(".btn-delete")[0].click
      expect(page).not_to have_content "anonymous 10 Delete"
      expect(@user.ratings.count).to eq(4)
    end

    it "when given ratings, favorite style is shown in the user-specific page" do
      visit user_path(@user)
      expect(page).to have_content "Favorite style is Lager"
    end

    it "when given ratings, favorite brewery is shown in the user-specific page" do
      visit user_path(@user)
      expect(page).to have_content "Favorite brewery is anonymous"
    end
  end
end
