require 'rails_helper'

RSpec.feature 'User Sign Up', type: :feature do
  scenario 'valid sign up' do
    visit new_user_registration_path

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'Password@123'
    fill_in 'Password confirmation', with: 'Password@123'
    fill_in 'Age', with: 25
    fill_in 'Date of birth', with: '1999-01-01'
    fill_in 'Phone number', with: '1234567890'

    click_button 'Sign up'
    expect(page).to have_content('Hello, John')
  end

  scenario 'invalid sign up - missing email' do
    visit new_user_registration_path
    click_button 'Sign up'
    expect(page).to have_content("Email can't be blank")
  end

  scenario 'invalid sign up - missing password' do
    visit new_user_registration_path
    click_button 'Sign up'
    expect(page).to have_content("Password can't be blank")
  end

  scenario 'invalid sign up - email exists' do
    existing_user = FactoryBot.create(:user, email: 'test@example.com')

    visit new_user_registration_path
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: existing_user.email
    fill_in 'Age', with: 25
    fill_in 'Phone number', with: '1234567890'
    fill_in 'Date of birth', with: '1998-01-01'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    click_button 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end
end
