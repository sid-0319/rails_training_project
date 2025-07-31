require 'rails_helper'

RSpec.describe 'Dashboard Access', type: :request do
  let(:password) { Faker::Internet.password(min_length: 8) }

  let(:staff)    { create(:user, role_type: :staff, status: :active, password: password) }
  let(:customer) { create(:user, role_type: :customer, status: :active, password: password) }

  describe 'GET /dashboard' do
    context 'when staff is signed in' do
      before do
        sign_in staff
        get '/dashboard'
      end

      it 'allows access to staff dashboard' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Staff')
      end
    end

    context 'when customer is signed in' do
      before do
        sign_in customer
        get '/dashboard'
      end

      it 'allows access to customer dashboard' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Customer')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get '/dashboard'
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

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
