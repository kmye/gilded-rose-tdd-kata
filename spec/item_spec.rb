require_relative '../src/item'

RSpec.describe Item do
  describe "#to_s" do
    it "should return the item name, sell-in and quality" do
      item=Item.new("Backstage passes", -1, 20)
      expect(item.to_s).to eq("Backstage passes, -1, 20")
    end
  end
end
