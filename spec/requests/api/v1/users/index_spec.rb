require 'rails_helper'

RSpec.describe 'API::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    let(:json_response) { JSON.parse(response.body) }

    context 'when retrieving all users' do
      before do
        create_list(:user, 5)
        get '/api/v1/users'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all users with required fields only' do
        expect(json_response.length).to eq(5)
        expect(json_response.first.keys).to match_array(%w[id first_name last_name email created_at])
      end

      it 'does not expose sensitive fields like password or encrypted_password' do
        user_keys = json_response.first.keys
        expect(user_keys).not_to include('password')
        expect(user_keys).not_to include('encrypted_password')
      end

      it 'returns valid data types for each field' do
        user = json_response.first
        expect(user['id']).to be_an(Integer)
        expect(user['first_name']).to be_a(String)
        expect(user['last_name']).to be_a(String)
        expect(user['email']).to be_a(String)
        expect { Time.parse(user['created_at']) }.not_to raise_error
      end

      it 'returns users ordered by creation time ascending (oldest first)' do
        creation_times = json_response.map { |u| Time.parse(u['created_at']) }
        expect(creation_times).to eq(creation_times.sort)
      end

      it 'returns unique emails for each user' do
        emails = json_response.map { |u| u['email'] }
        expect(emails.uniq.length).to eq(emails.length)
      end
    end

    context 'when filtering users' do
      it 'filters users by first_name' do
        create(:user, first_name: 'John')
        create(:user, first_name: 'Jane')

        get '/api/v1/users', params: { first_name: 'John' }

        expect(json_response.length).to eq(1)
        expect(json_response.first['first_name']).to eq('John')
      end

      it 'filters users by last_name' do
        create(:user, last_name: 'Doe')
        create(:user, last_name: 'Smith')

        get '/api/v1/users', params: { last_name: 'Doe' }

        expect(json_response.length).to eq(1)
        expect(json_response.first['last_name']).to eq('Doe')
      end

      it 'filters users by email' do
        create(:user, email: 'john@example.com')
        create(:user, email: 'jane@example.com')

        get '/api/v1/users', params: { email: 'john@example.com' }

        expect(json_response.length).to eq(1)
        expect(json_response.first['email']).to eq('john@example.com')
      end
    end
  end
end
