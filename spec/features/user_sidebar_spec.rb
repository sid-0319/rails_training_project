require 'rails_helper'

RSpec.describe 'User Sidebar Navigation', type: :feature do
  let(:user) { create(:user, role_type: :staff, first_name: 'Test', last_name: 'User') }

  before do
    login_as(user, scope: :user)
    visit root_path
  end

  it 'shows user avatar or default image' do
    if user.avatar.attached?
      expect(page).to have_css('img.rounded-circle')
    else
      expect(page).to have_css("img[src*='default_img.png']")
    end
  end

  it 'displays main menu options for staff' do
    # Staff user should see "My Profile", "Restaurants", "View Feedbacks", "Sign out"
    expect(page).to have_link('My Profile')
    expect(page).to have_link('Restaurants')
    expect(page).to have_link('View Feedbacks')
    expect(page).to have_button('Sign out')
  end

  it 'has correct links under My Profile' do
    click_link 'My Profile'
    expect(page).to have_link('Update Avatar', href: edit_avatar_path)
    expect(page).to have_link('Update Personal Data', href: edit_user_registration_path)
  end

  it 'has correct restaurant links' do
    click_link 'Restaurants'
    expect(page).to have_link('Restaurants', href: restaurants_path)
    expect(page).to have_link('Create Restaurant', href: new_restaurant_path)
  end

  it 'allows user to sign out and redirects to homepage' do
    click_button 'Sign out'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Welcome!')
  end
end
