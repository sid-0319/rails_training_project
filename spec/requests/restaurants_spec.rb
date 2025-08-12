require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let(:token)   { create(:token, expired_at: 1.day.from_now) }
  let(:headers) { { 'Authorization' => "Bearer #{token.value}", 'ACCEPT' => 'application/json' } }
  let(:restaurant) { create(:restaurant) }

  describe 'POST /restaurants' do
    it 'creates a restaurant with valid params' do
      valid_params = { restaurant: { name: 'Test Resto', description: 'Nice place' } }

      expect do
        post '/restaurants', params: valid_params, headers: headers
      end.to change(Restaurant, :count).by(1)

      expect(response).to have_http_status(:created).or have_http_status(:ok)
    end

    it 'returns errors for missing name' do
      invalid_params = { restaurant: { description: 'No name here' } }

      post '/restaurants', params: invalid_params, headers: headers
      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
    end
  end

  describe 'GET /restaurants' do
    it 'returns all restaurants' do
      create_list(:restaurant, 3)

      get '/restaurants', headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns an empty array if no restaurants exist' do
      get '/restaurants', headers: headers
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe 'DELETE /restaurants/:id' do
    it 'deletes the restaurant' do
      resto = create(:restaurant)

      expect do
        delete "/restaurants/#{resto.id}", headers: headers
      end.to change(Restaurant, :count).by(-1)

      expect(response).to have_http_status(:no_content).or have_http_status(:ok)
    end

    it 'returns not found for invalid ID' do
      delete '/restaurants/999999', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'auth without token' do
    it 'returns unauthorized without token' do
      post '/restaurants', params: { restaurant: { name: 'X', description: 'Y' } },
                           headers: { 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  it 'GET /restaurants responds with JSON format' do
    get '/restaurants', headers: headers
    expect(response.content_type).to include('application/json')
  end

  it 'returns restaurant details for a valid ID' do
    resto = create(:restaurant, name: 'Detail Test')
    get "/restaurants/#{resto.id}", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Detail Test')
  end

  it 'returns not found for GET with invalid ID' do
    get '/restaurants/999999', headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it 'POST /restaurants with extra unused params still works' do
    post '/restaurants',
         params: { restaurant: { name: 'Extra Fields', description: 'Cool', extra_param: 'ignore me' } }, headers: headers
    expect(response).to have_http_status(:created).or have_http_status(:ok)
  end

  it 'PATCH /restaurants/:id updates name' do
    resto = create(:restaurant, name: 'Old Name')
    patch "/restaurants/#{resto.id}", params: { restaurant: { name: 'New Name' } }, headers: headers
    expect(response).to have_http_status(:ok)
    resto.reload
    expect(resto.name).to eq('New Name')
  end

  it 'does not update restaurant with empty name' do
    resto = create(:restaurant, name: 'Still Here')
    patch "/restaurants/#{resto.id}", params: { restaurant: { name: '' } }, headers: headers
    resto.reload
    expect(resto.name).to eq('Still Here')
  end

  it 'sorts restaurants by name' do
    create(:restaurant, name: 'Bistro')
    create(:restaurant, name: 'Alpha')
    get '/restaurants', params: { sort: 'name' }, headers: headers
    names = JSON.parse(response.body).map { |r| r['name'] }
    expect(names).to eq(names.sort)
  end

  # Sorting by rating (DESC)
  it 'sorts restaurants by rating' do
    create(:restaurant, name: 'Low', rating: 1.0)
    create(:restaurant, name: 'High', rating: 5.0)
    get '/restaurants', params: { sort: 'rating' }, headers: headers
    ratings = JSON.parse(response.body).map { |r| r['rating'] }
    expect(ratings).to eq(ratings.sort.reverse)
  end

  it 'GET /restaurants handles pagination params gracefully' do
    create_list(:restaurant, 5)
    get '/restaurants', params: { page: 1, per_page: 2 }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'DELETE /restaurants without existing record returns not found' do
    delete '/restaurants/123456789', headers: headers
    expect(response).to have_http_status(:not_found)
  end
end
