# spec/requests/restaurants_spec.rb
require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /restaurants/new' do
    it 'renders the new restaurant form' do
      get new_restaurant_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /restaurants' do
    context 'with valid data' do
      it 'creates a new restaurant and redirects' do
        expect do
          post restaurants_path, params: {
            restaurant: {
              name: 'New Spot',
              description: 'Tasty food',
              location: 'Delhi',
              cuisine_type: 'Indian'
            }
          }
        end.to change(Restaurant, :count).by(1)

        expect(Restaurant.last.status).to eq('open')
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Your Restaurant was created and is open for business.')
      end
    end

    context 'with invalid data' do
      it 'does not create a restaurant' do
        expect do
          post restaurants_path, params: {
            restaurant: {
              name: '',
              description: '',
              location: '',
              cuisine_type: ''
            }
          }
        end.not_to change(Restaurant, :count)

        expect(response.body).to include("can't be blank")
      end
    end
  end
end
