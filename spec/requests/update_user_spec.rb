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

    # Additional GET cases
    it 'redirects to sign in if not logged in' do
      delete destroy_user_session_path
      get edit_user_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'includes current user first and last name in form' do
      get edit_user_registration_path
      expect(response.body).to include(user.first_name)
      expect(response.body).to include(user.last_name)
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
      expect(response.body).to include('can&#39;t be blank')
    end

    it 'with missing last name shows validation error' do
      put user_registration_path, params: {
        user: {
          first_name: 'NewFirst',
          last_name: '',
          current_password: 'password123'
        }
      }
      expect(response.body).to include('can&#39;t be blank')
    end

    it 'with missing current password shows validation error' do
      put user_registration_path, params: {
        user: {
          first_name: 'NewFirst',
          last_name: 'NewLast'
          # missing current_password
        }
      }
      expect(response.body).to include('can&#39;t be blank')
    end

    # Additional PUT cases
    it 'does not update with incorrect current password' do
      put user_registration_path, params: {
        user: {
          first_name: 'WrongPass',
          last_name: 'User',
          current_password: 'wrongpassword'
        }
      }
      expect(response.body).to include('is invalid')
    end

    it 'updates email with correct password' do
      new_email = 'newemail@example.com'
      put user_registration_path, params: {
        user: {
          email: new_email,
          current_password: 'password123'
        }
      }
      expect(user.reload.email).to eq(new_email)
    end

    it 'does not update email with incorrect password' do
      old_email = user.email
      put user_registration_path, params: {
        user: {
          email: 'invalidupdate@example.com',
          current_password: 'wrongpassword'
        }
      }
      expect(user.reload.email).to eq(old_email)
    end

    it 'updates password with correct current password' do
      put user_registration_path, params: {
        user: {
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
          current_password: 'password123'
        }
      }
      delete destroy_user_session_path
      post user_session_path, params: {
        user: { email: user.email, password: 'newpassword123' }
      }
      expect(response).to redirect_to(root_path)
    end

    it 'does not update password when confirmation does not match' do
      put user_registration_path, params: {
        user: {
          password: 'newpassword123',
          password_confirmation: 'wrongconfirmation',
          current_password: 'password123'
        }
      }
      expect(response.body).to include('doesn&#39;t match Password')
    end

    it 'returns validation error when email format is invalid' do
      put user_registration_path, params: {
        user: {
          email: 'invalid_email',
          current_password: 'password123'
        }
      }
      expect(response.body).to include('is invalid')
    end

    it 'does not allow update if user is not logged in' do
      delete destroy_user_session_path
      put user_registration_path, params: {
        user: {
          first_name: 'NoLogin',
          last_name: 'Attempt',
          current_password: 'password123'
        }
      }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
