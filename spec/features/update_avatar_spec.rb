require 'rails_helper'
require 'warden/test/helpers'

RSpec.describe 'Update Avatar', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  context 'avatar upload form' do
    before do
      # Ensure user has no avatar attached before visiting the page
      user.avatar.purge if user.avatar.attached?
      visit edit_avatar_path
    end

    it 'does not show delete button if no avatar attached' do
      expect(page).not_to have_button('Delete avatar')
    end
  end
end
