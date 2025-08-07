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
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu_item)).to be_valid
    end
  end
end
