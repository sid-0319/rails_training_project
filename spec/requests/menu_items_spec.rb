require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:item_name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:description) }

    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it 'allows true or false for is_vegetarian' do
      menu_item = build(:menu_item, is_vegetarian: true)
      expect(menu_item).to be_valid

      menu_item.is_vegetarian = false
      expect(menu_item).to be_valid
    end

    context 'invalid price values' do
      it 'rejects negative price' do
        menu_item = build(:menu_item, price: -5)
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:price]).to include('must be greater than or equal to 0')
      end

      it 'rejects non-numeric price' do
        menu_item = build(:menu_item, price: 'abc')
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:price]).to include('is not a number')
      end
    end

    context 'blank fields' do
      it 'is invalid without an item_name' do
        menu_item = build(:menu_item, item_name: nil)
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:item_name]).to include("can't be blank")
      end

      it 'is invalid without a category' do
        menu_item = build(:menu_item, category: nil)
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:category]).to include("can't be blank")
      end

      it 'is invalid without a description' do
        menu_item = build(:menu_item, description: nil)
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:description]).to include("can't be blank")
      end
    end
  end

  describe 'edge cases' do
    it 'allows price to be exactly 0' do
      menu_item = build(:menu_item, price: 0)
      expect(menu_item).to be_valid
    end

    it 'allows large price values' do
      menu_item = build(:menu_item, price: 9999.99)
      expect(menu_item).to be_valid
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu_item)).to be_valid
    end
  end
end
