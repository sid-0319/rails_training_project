require 'rails_helper'

RSpec.describe 'API::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    before do
      create_list(:user, 5)
      get '/api/v1/users'
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all users with required fields only' do
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(5)
      expect(json_response.first.keys).to match_array(%w[id first_name last_name email created_at])
    end

    it 'does not expose sensitive fields like password or encrypted_password' do
      json_response = JSON.parse(response.body)
      user_keys = json_response.first.keys
      expect(user_keys).not_to include('password')
      expect(user_keys).not_to include('encrypted_password')
    end

    it 'returns valid data types for each field' do
      json_response = JSON.parse(response.body)
      user = json_response.first
      expect(user['id']).to be_an(Integer)
      expect(user['first_name']).to be_a(String)
      expect(user['last_name']).to be_a(String)
      expect(user['email']).to be_a(String)
      expect { Time.parse(user['created_at']) }.not_to raise_error
    end

    it 'returns users ordered by creation time ascending (oldest first)' do
      json_response = JSON.parse(response.body)
      creation_times = json_response.map { |u| Time.parse(u['created_at']) }
      expect(creation_times).to eq(creation_times.sort)
    end

    it 'returns unique emails for each user' do
      json_response = JSON.parse(response.body)
      emails = json_response.map { |u| u['email'] }
      expect(emails.uniq.length).to eq(emails.length)
    end
  end
end
