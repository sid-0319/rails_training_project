require 'rails_helper'

RSpec.feature "User Sign In", type: :feature do
  let(:user) { create(:user, password: "Password@123") }

  scenario "valid sign in" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "Password@123"
    click_button "Log in"

    expect(page).to have_content("Hello, #{user.first_name}")
  end

  scenario "invalid sign in - wrong password" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_content("Invalid Email or password")
  end

  scenario "email and password cannot be empty" do
    visit new_user_session_path
    fill_in "Email", with: ""
    fill_in "Password", with: ""
    click_button "Log in"

    expect(page).to have_content("Invalid Email or password")
  end
end
