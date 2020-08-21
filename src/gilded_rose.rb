require_relative 'item'

class Constants
  ITEM_NAME_AGED_BRIE = "Aged Brie".freeze
  ITEM_NAME_BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
  ITEM_NAME_SULFURAS = "Sulfuras, Hand of Ragnaros".freeze

  ITEMS_INCREASES_QUALITY = [ITEM_NAME_AGED_BRIE, ITEM_NAME_BACKSTAGE_PASSES].freeze
  ITEMS_QUALITY_NEVER_CHANGE = [ITEM_NAME_SULFURAS].freeze

  MAX_ITEM_QUALITY = 50.freeze
  MIN_ITEM_QUALITY = 0.freeze

  MIN_SELL_IN = 0.freeze

  SELL_IN_INCREASE_BY_2_BACKSTAGE_PASSES = 10.freeze
  SELL_IN_INCREASE_BY_3_BACKSTAGE_PASSES = 5.freeze
end

class GildedRose

  def initialize(items)
    @items = items
  end

  def item_should_increase_quality?(item)
    Constants::ITEMS_INCREASES_QUALITY.include? item.name
  end

  def item_should_not_decrease_quality?(item)
    Constants::ITEMS_QUALITY_NEVER_CHANGE.include? item.name
  end

  def item_can_increase_quality?(item)
    item.quality < Constants::MAX_ITEM_QUALITY
  end

  def increase_item_quality item
    if item_can_increase_quality? item
      item.quality = item.quality + 1
    end
  end

  def calculate_quality_for_backstage_passes(item)
    if item.sell_in <= Constants::SELL_IN_INCREASE_BY_2_BACKSTAGE_PASSES
      increase_item_quality item
    end
    if item.sell_in < Constants::SELL_IN_INCREASE_BY_3_BACKSTAGE_PASSES
      increase_item_quality item
    end

    if item.sell_in < Constants::MIN_SELL_IN
      item.quality = Constants::MIN_ITEM_QUALITY
    end
  end

  def decrease_item_quality (item)
    unless item_should_not_decrease_quality? item
      if item.quality > Constants::MIN_ITEM_QUALITY
        item.quality = item.quality - 1
      end
    end
  end

  def update_sell_in (item)
    if item.name != Constants::ITEM_NAME_SULFURAS
      item.sell_in = item.sell_in - 1
    end
  end

  def calculate_quality_for_item_past_sell_in(item)
    if item.name != Constants::ITEM_NAME_AGED_BRIE
      decrease_item_quality item
    else
      increase_item_quality item
    end
  end

  def calculate_base_quality(item)
    if item_should_increase_quality? item
      increase_item_quality item
    else
      decrease_item_quality item
    end
  end

  def update_quality
    @items.each do |item|
      update_sell_in item
      calculate_base_quality item
      calculate_quality_for_backstage_passes item if item.name == Constants::ITEM_NAME_BACKSTAGE_PASSES
      calculate_quality_for_item_past_sell_in item if item.sell_in < Constants::MIN_SELL_IN
    end
  end
end

