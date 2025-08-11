require 'rails_helper'

RSpec.describe 'Dashboard Access', type: :request do
  let(:password) { Faker::Internet.password(min_length: 8) }

  describe 'POST /users/sign_in' do
    context 'when email is incorrect' do
      it 'does not sign in the user and re-renders the login page' do
        post user_session_path, params: {
          user: {
            email: Faker::Internet.email,
            password: password
          }
        }
        expect(response.body).to include('Invalid Email or password')
      end
    end

    context 'when password is incorrect' do
      let(:staff) do
        create(:user, role_type: :staff, account_status: :active, password: password, password_confirmation: password)
      end

      it 'does not sign in the user and re-renders the login page' do
        post user_session_path, params: {
          user: {
            email: staff.email,
            password: 'wrongpassword'
          }
        }
        expect(response.body).to include('Invalid Email or password')
      end
    end

    context 'when both email and password are incorrect' do
      it 'does not sign in the user and re-renders the login page' do
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
end
