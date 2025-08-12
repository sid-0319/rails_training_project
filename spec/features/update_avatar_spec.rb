require 'rails_helper'
require 'warden/test/helpers'

RSpec.describe 'Update Avatar', type: :feature do
  let(:user) { create(:user) }

  before do
    Warden.test_mode!
  end

  after do
    Warden.test_reset!
  end

  context 'when logged in' do
    before do
      login_as(user, scope: :user)
    end

    it 'uploads and displays avatar' do
      visit edit_avatar_path
      attach_file 'user_avatar', Rails.root.join('spec/fixtures/avatar.png')
      click_button 'Upload'

      expect(page).to have_content('Avatar updated successfully')
      expect(page).to have_selector("img[src*='avatar.png']")
    end

    it 'shows delete button and deletes avatar if attached' do
      user.avatar.attach(
        io: File.open(Rails.root.join('spec/fixtures/avatar.png')),
        filename: 'avatar.png',
        content_type: 'image/png'
      )
      visit edit_avatar_path
      expect(page).to have_button('Delete avatar')
      click_button 'Delete avatar'
      expect(page).to have_content('Avatar deleted successfully')
      expect(user.reload.avatar).not_to be_attached
    end

    it 'does not show delete button if no avatar attached' do
      user.avatar.purge if user.avatar.attached?
      visit edit_avatar_path
      expect(page).not_to have_button('Delete avatar')
    end

    it 'shows error when uploading invalid file type' do
      visit edit_avatar_path
      attach_file 'user_avatar', Rails.root.join('spec/fixtures/invalid.txt')
      click_button 'Upload'
      expect(page).to have_content('Invalid file format')
    end

    it 'shows error for large avatar file' do
      visit edit_avatar_path
      attach_file 'user_avatar', Rails.root.join('spec/fixtures/too_large.png')
      click_button 'Upload'
      expect(page).to have_content('Avatar size must be less than 2MB')
    end
  end

  context 'when logged out' do
    it 'redirects to sign-in page' do
      visit edit_avatar_path
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
