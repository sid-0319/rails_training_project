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
        }
      }
      expect(response.body).to include('can&#39;t be blank')
    end
  end

  it 'redirects to sign in if not logged in' do
    delete destroy_user_session_path
    get edit_user_registration_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'has a working sign out path' do
    delete destroy_user_session_path
    expect(response).to redirect_to(root_path)
  end

  it 'GET /users/edit contains first name field' do
    get edit_user_registration_path
    expect(response.body).to include('first_name')
  end

  it 'GET /users/edit contains last name field' do
    get edit_user_registration_path
    expect(response.body).to include('last_name')
  end

  it 'GET /users/edit contains current password field' do
    get edit_user_registration_path
    expect(response.body).to include('current_password')
  end

  it 'does not change user if update params are empty' do
    original_first = user.first_name
    put user_registration_path, params: {
      user: {
        first_name: '',
        last_name: '',
        current_password: 'password123'
      }
    }
    user.reload
    expect(user.first_name).to eq(original_first)
  end

  it 'renders edit page again when update fails' do
    put user_registration_path, params: {
      user: {
        first_name: '',
        last_name: '',
        current_password: 'password123'
      }
    }
    expect(response.body).to include('Edit')
  end

  it 'GET /users/edit returns HTML content type' do
    get edit_user_registration_path
    expect(response.content_type).to include('text/html')
  end

  it 'PUT /users redirects to root after successful update' do
    put user_registration_path, params: {
      user: {
        first_name: 'Updated',
        last_name: 'Name',
        current_password: 'password123'
      }
    }
    expect(response).to redirect_to(root_path)
  end

  it 'keeps the same email if email not provided in update' do
    original_email = user.email
    put user_registration_path, params: {
      user: {
        first_name: 'X',
        last_name: 'Y',
        current_password: 'password123'
      }
    }
    user.reload
    expect(user.email).to eq(original_email)
  end
end
