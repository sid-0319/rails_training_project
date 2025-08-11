require 'rails_helper'

RSpec.feature 'Dashboard Access', type: :feature do
  let(:password) { Faker::Internet.password(min_length: 8) }

  let(:staff) do
    create(:user,
           role_type: :staff,
           account_status: :active,
           password: password,
           password_confirmation: password)
  end

  let(:customer) do
    create(:user,
           role_type: :customer,
           account_status: :active,
           password: password,
           password_confirmation: password)
  end

  scenario 'Staff can access the staff dashboard' do
    login_as(staff, scope: :user)
    visit '/dashboard'
    expect(page).to have_content('Staff')
  end

  scenario 'Customer can access the customer dashboard' do
    login_as(customer, scope: :user)
    visit '/dashboard'
    expect(page).to have_content('Customer')
  end

  scenario 'Guest is redirected to sign-in page' do
    visit '/dashboard'
    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'Sign in fails with incorrect email' do
    visit new_user_session_path
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'Sign in fails with incorrect password' do
    visit new_user_session_path
    fill_in 'Email', with: staff.email
    fill_in 'Password', with: 'wrongpassword'
    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'Sign in fails with incorrect email and password' do
    visit new_user_session_path
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'wrongpassword'
    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password')
  end
end
