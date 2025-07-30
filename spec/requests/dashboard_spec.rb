require 'rails_helper'

RSpec.describe 'Dashboard Access', type: :request do
  let(:admin) { create(:user, role_type: :admin, status: :active) }
  let(:staff) { create(:user, role_type: :staff, status: :active) }
  let(:customer) { create(:user, role_type: :customer, status: :active) }

  describe 'GET /dashboard' do
    context 'when admin is signed in' do
      before do
        sign_in admin
        get '/dashboard'
      end

      it 'allows access' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Admin')
      end
    end

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
end
