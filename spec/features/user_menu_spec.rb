require 'rails_helper'

RSpec.describe 'User Menu', type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path(role: 'customer') # specify role param as per user role

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit root_path
  end

  let(:menu_selector) { '.col-md-3.d-none.d-md-block > div.vh-100.bg-white.p-4.shadow-sm ul.nav.flex-column' }

  it 'shows main options with icons' do
    within(first(menu_selector)) do
      expect(page).to have_link('My Profile')
      expect(page).to have_link('Restaurants')
      expect(page).to have_button('Sign out')

      expect(page).to have_selector('a.nav-link.fw-bold i.fas.fa-user')
      expect(page).to have_selector('a.nav-link.fw-bold i.fas.fa-book')
      expect(page).to have_selector('button.nav-link.text-danger i.fas.fa-sign-out-alt')
    end
  end

  it 'toggles My Profile submenu' do
    within(first(menu_selector)) do
      click_on 'My Profile'
      expect(page).to have_link('Update Avatar')
      expect(page).to have_link('Update Personal Data')

      click_on 'My Profile'
      # wait for collapse animation if needed
      expect(page).not_to have_css('#profileMenu.show')
      # or check submenu container is collapsed
      # expect(page).to have_no_css('#profileMenu.show')
    end
  end

  it 'toggles Restaurants submenu' do
    within(first(menu_selector)) do
      # Click main 'Restaurants' menu (with fw-bold class) to toggle
      find('a.nav-link.fw-bold', text: 'Restaurants').click

      within('#booksMenu') do
        expect(page).to have_link('Restaurants')
        expect(page).to have_link('Create Restaurant')
      end

      # collapse again
      find('a.nav-link.fw-bold', text: 'Restaurants').click
      expect(page).to have_no_css('#booksMenu.show')
    end
  end

  it 'signs out user and redirects to homepage' do
    within(first(menu_selector)) do
      click_button 'Sign out'
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Signed out successfully.')
  end
end
