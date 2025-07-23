require 'rails_helper'

RSpec.describe 'User Personal Information Update', type: :request do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }

  before do
    puts method(:sign_in).source_location
    sign_in(user)
  end

  describe 'GET /users/edit' do
    it 'renders the edit form with current user data' do
      get edit_user_registration_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Edit User')
      expect(response.body).to include('value="john@example.com"')
      expect(response.body).to include('Update')
    end
  end

  describe 'PUT /users' do
    context 'with valid data' do
      it 'updates user details' do
        put user_registration_path, params: {
          user: {
            first_name: 'Jane',
            last_name: 'Smith',
            email: 'jane@example.com',
            current_password: 'password123'
          }
        }

        follow_redirect!

        expect(response.body).to include('Your account has been updated successfully.')
        user.reload
        expect(user.first_name).to eq('Jane')
        expect(user.last_name).to eq('Smith')
        expect(user.email).to eq('jane@example.com')
      end
    end

    context 'with missing first name' do
      it 'shows validation error' do
        put user_registration_path, params: {
          user: {
            first_name: '',
            last_name: 'Smith',
            email: 'jane@example.com',
            current_password: 'password123'
          }
        }

        expect(response.body).to include("First name can't be blank")
      end
    end

    context 'with missing last name' do
      it 'shows validation error' do
        put user_registration_path, params: {
          user: {
            first_name: 'Jane',
            last_name: '',
            email: 'jane@example.com',
            current_password: 'password123'
          }
        }

        expect(response.body).to include("Last name can't be blank")
      end
    end

    context 'with missing current password' do
      it 'shows validation error' do
        put user_registration_path, params: {
          user: {
            first_name: 'Jane',
            last_name: 'Smith',
            email: 'jane@example.com',
            current_password: ''
          }
        }

        expect(response.body).to include("Current password can't be blank")
      end
    end
  end
end
