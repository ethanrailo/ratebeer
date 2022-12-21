require "rails_helper"

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )
    allow(WeatherstackApi).to receive(:weather_in).with("kumpula").and_return(
      false
    )

    visit places_path
    fill_in("city", with: "kumpula")
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("riihimäki").and_return(
      [Place.new(name: "Hopeaharakka", id: 1), Place.new(name: "Tanssi- ja painiravintola Rity", id: 2), Place.new(name: "Yläpelti", id: 3)]
    )
    allow(WeatherstackApi).to receive(:weather_in).with("riihimäki").and_return(
      false
    )

    visit places_path
    fill_in("city", with: "riihimäki")
    click_button "Search"

    expect(page).to have_content "Hopeaharakka"
    expect(page).to have_content "Tanssi- ja painiravintola Rity"
    expect(page).to have_content "Yläpelti"
  end

  it "if none is returned by the API, helper text is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("korso").and_return(
      []
    )
    allow(WeatherstackApi).to receive(:weather_in).with("korso").and_return(
      false
    )

    visit places_path
    fill_in("city", with: "korso")
    click_button "Search"

    expect(page).to have_content "No locations in korso"
  end
end
