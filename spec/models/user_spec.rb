require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a first name' do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid? # This triggers validations
    expect(user).to_not be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end
end
