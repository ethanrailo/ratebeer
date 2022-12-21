require "rails_helper"

RSpec.describe Beer, type: :model do
  it "is not saved without a name" do
    test_style = Style.new name: "lager", description: "yasss"
    beer = Beer.create style: test_style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "Kalex"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  describe "with a name, a style and a existing brewery" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_style) { Style.new name: "lager", description: "yasss" }
    let(:beer) { Beer.create name: "Kalex", style: test_style, brewery: test_brewery }

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
