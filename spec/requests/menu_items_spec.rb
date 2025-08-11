require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:item_name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:category) }

    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it 'allows true or false for is_vegetarian' do
      menu_item = build(:menu_item, is_vegetarian: true)
      expect(menu_item).to be_valid

      menu_item.is_vegetarian = false
      expect(menu_item).to be_valid
    end

    # Extra examples start here
    it 'is invalid without an item_name' do
      menu_item = build(:menu_item, item_name: nil)
      expect(menu_item).not_to be_valid
    end

    it 'is invalid without a category' do
      menu_item = build(:menu_item, category: nil)
      expect(menu_item).not_to be_valid
    end

    it 'is invalid without a price' do
      menu_item = build(:menu_item, price: nil)
      expect(menu_item).not_to be_valid
    end

    it 'is invalid if price is negative' do
      menu_item = build(:menu_item, price: -5)
      expect(menu_item).not_to be_valid
    end

    it 'is valid with a price of zero' do
      menu_item = build(:menu_item, price: 0)
      expect(menu_item).to be_valid
    end

    it 'is valid with decimal price' do
      menu_item = build(:menu_item, price: 9.99)
      expect(menu_item).to be_valid
    end

    it 'is invalid if restaurant is missing' do
      menu_item = build(:menu_item, restaurant: nil)
      expect(menu_item).not_to be_valid
    end

    it 'is valid with all required attributes' do
      expect(build(:menu_item)).to be_valid
    end

    it 'is invalid if item_name exceeds 255 characters' do
      menu_item = build(:menu_item, item_name: 'a' * 256)
      expect(menu_item).not_to be_valid
    end

    it 'is valid if is_vegetarian is nil (optional)' do
      menu_item = build(:menu_item, is_vegetarian: nil)
      expect(menu_item).to be_valid
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu_item)).to be_valid
    end
  end
end
