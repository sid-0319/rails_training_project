require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:comment) }

    it 'is valid with valid attributes' do
      feedback = build(:feedback)
      expect(feedback).to be_valid
    end

    it 'is invalid without a rating' do
      feedback = build(:feedback, rating: nil)
      expect(feedback).to_not be_valid
    end

    it 'is invalid without a comment' do
      feedback = build(:feedback, comment: nil)
      expect(feedback).to_not be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:restaurant).optional }
  end
end
