require 'rails_helper'

RSpec.describe 'Dashboard Access', type: :request do
  include Devise::Test::IntegrationHelpers
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

  describe 'GET /dashboard' do
    it 'allows staff to access staff dashboard' do
      sign_in staff
      get '/dashboard'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Staff')
    end

    it 'allows customer to access customer dashboard' do
      sign_in customer
      get '/dashboard'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Customer')
    end

    it 'redirects guests to sign-in page' do
      get '/dashboard'
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /users/sign_in' do
    it 'fails with incorrect email' do
      post user_session_path, params: {
        user: {
          email: Faker::Internet.email,
          password: password
        }
      }
      expect(response.body).to include('Invalid Email or password')
    end

    it 'fails with incorrect password' do
      post user_session_path, params: {
        user: {
          email: staff.email,
          password: 'wrongpassword'
        }
      }
      expect(response.body).to include('Invalid Email or password')
    end

    it 'fails with incorrect email and password' do
      post user_session_path, params: {
        user: {
          email: Faker::Internet.email,
          password: 'wrongpassword'
        }
      }
      expect(response.body).to include('Invalid Email or password')
    end
  end
end
