require 'rails_helper'

RSpec.describe 'Dashboard Access', type: :request do
  let(:admin) { create(:user, role_type: :admin, status: :active, email: 'admin@example.com', password: 'password123') }
  let(:staff) { create(:user, role_type: :staff, status: :active, email: 'staff@example.com', password: 'password123') }
  let(:customer) do
    create(:user, role_type: :customer, status: :active, email: 'customer@example.com', password: 'password123')
  end

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
        post user_session_path, params: { user: { email: 'wrong@example.com', password: 'password123' } }
        expect(response.body).to include('Invalid Email or password')
      end
    end

    context 'when password is incorrect' do
      it 'does not sign in the user and re-renders the login page' do
        post user_session_path, params: { user: { email: staff.email, password: 'wrongpass' } }
        expect(response.body).to include('Invalid Email or password')
      end
    end

    context 'when both email and password are incorrect' do
      it 'does not sign in the user and re-renders the login page' do
        post user_session_path, params: { user: { email: 'wrong@example.com', password: 'wrongpass' } }
        expect(response.body).to include('Invalid Email or password')
      end
    end
  end
end
