require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:cuisine_type) }
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5).allow_nil }

  it 'has valid AASM states' do
    expect(subject.aasm.states.map(&:name)).to include(:open, :closed, :archived)
  end

  it 'defaults to open status' do
    expect(subject.status).to eq('open')
  end
end
