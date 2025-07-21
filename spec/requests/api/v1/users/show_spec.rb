require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id', type: :request do
  let!(:user) { create(:user) }

  context 'when the user exists' do
    it 'returns the user' do
      get "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(user.id)
      expect(json['email']).to eq(user.email)
    end
  end

  context 'when the user does not exist' do
    it 'returns 404 not found' do
      get '/api/v1/users/99999'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end

  context 'when ID is a string' do
    it 'returns 404 not found' do
      get '/api/v1/users/abc'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end

  context 'when ID is a negative number' do
    it 'returns 404 not found' do
      get '/api/v1/users/-1'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end

  context 'when ID is 0' do
    it 'returns 404 not found' do
      get '/api/v1/users/0'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end

  context 'when ID contains special characters' do
    it 'returns 404 not found' do
      escaped_id = CGI.escape('@#%')
      get "/api/v1/users/#{escaped_id}"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end

  context 'when ID contains whitespace' do
    it 'returns 404 not found' do
      escaped_id = CGI.escape('   ')
      get "/api/v1/users/#{escaped_id}"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('User not found')
    end
  end
end
