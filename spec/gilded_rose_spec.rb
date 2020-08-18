require_relative '../src/gilded_rose'

RSpec.describe GildedRose do

  describe "#update_quality" do

    describe "Normal Items" do
      it "does not change the name" do
        items = [Item.new("foo", 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].name).to eq "foo"
      end

      it "should degrade in quality twice as fast when sell by date has passed" do
        items = [Item.new("foo", 0, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 18
      end

      it "should not have quality of negative value" do
        items = [Item.new("foo", 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

    end

    describe "Aged Brie" do

      it "should increase in quality for Aged Brie" do
        items = [Item.new("Aged Brie", 1, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 1
      end

      it "should have capped the quality at 50 for Aged Brie" do
        items = [Item.new("Aged Brie", 1, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end

      it "should increase in quality by 2 when sell in is negative" do
        items = [Item.new("Aged Brie", -1, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 2
      end
    end

    describe "Sulfuras, Hand of Ragnaros" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 15, 20)]
      it "should not decrease in quality " do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 20
      end

      it "should not decrease in sell-in " do
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 15
      end
    end

    describe "Backstage passes to a TAFKAL80ETC concert" do

      it "should increase quality by 2 when sell-in is 10 days or less" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 22
      end

      it "should increase quality by 3 when sell-in is 10 days or less" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 23
      end

      it "should have quality 0 after the concert" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end
    end

  end



end
