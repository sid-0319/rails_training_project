require 'rails_helper'

RSpec.describe 'User Personal Information Update', type: :request do
  let(:user) { create(:user, role_type: :staff, password: 'password123', password_confirmation: 'password123') }

  before do
    # Sign in using Devise session path
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'password123'
      }
    }
  end

  describe 'GET /users/edit' do
    it 'renders the edit form with current user data' do
      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Edit')
    end
  end

  describe 'PUT /users' do
    it 'with valid data updates user details' do
      put user_registration_path, params: {
        user: {
          first_name: 'NewFirst',
          last_name: 'NewLast',
          current_password: 'password123'
        }
      }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('NewFirst')
    end

    it 'with missing first name shows validation error' do
      put user_registration_path, params: {
        user: {
          first_name: '',
          last_name: 'NewLast',
          current_password: 'password123'
        }
      }
      expect(response.body).to include("can't be blank")
    end

    it 'with missing last name shows validation error' do
      put user_registration_path, params: {
        user: {
          first_name: 'NewFirst',
          last_name: '',
          current_password: 'password123'
        }
      }
      expect(response.body).to include("can't be blank")
    end

    it 'with missing current password shows validation error' do
      put user_registration_path, params: {
        user: {
          first_name: 'NewFirst',
          last_name: 'NewLast'
          # missing current_password
        }
      }
      expect(response.body).to include("can't be blank")
    end
  end
end
