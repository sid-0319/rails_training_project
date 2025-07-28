require 'rails_helper'

RSpec.describe 'API::V1::Restaurants', type: :request do
  let(:user) { create(:user) }
  let(:token) { create(:token, user: user) }
  let(:headers) { { 'Authorization' => "Bearer #{token.value}" } }

  describe 'POST /api/v1/restaurants' do
    let(:valid_params) do
      {
        name: 'Pizza Palace',
        description: 'Best Italian food',
        location: 'New York',
        cuisine_type: 'Italian',
        rating: 4.5,
        note: 'Great service'
      }
    end

    it 'creates a restaurant with valid params' do
      post '/api/v1/restaurants', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('Pizza Palace')
    end

    it 'returns errors for invalid data' do
      post '/api/v1/restaurants', params: valid_params.except(:name), headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
    end
  end

  describe 'GET /api/v1/restaurants' do
    before { create_list(:restaurant, 3, user: user) }

    it 'returns all restaurants' do
      get '/api/v1/restaurants', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'PUT /api/v1/restaurants/:id' do
    let(:restaurant) { create(:restaurant, user: user) }

    it 'updates the restaurant' do
      put "/api/v1/restaurants/#{restaurant.id}", params: { name: 'Updated Name' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/v1/restaurants/:id' do
    let!(:restaurant) { create(:restaurant, user: user) }

    it 'deletes the restaurant' do
      expect do
        delete "/api/v1/restaurants/#{restaurant.id}", headers: headers
      end.to change(Restaurant, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Restaurant deleted successfully')
    end
  end
end
