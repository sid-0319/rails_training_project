require 'rails_helper'

RSpec.describe 'API::V1::Users Create', type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      {
        first_name: 'Test',
        last_name: 'User',
        email: 'test.user@example.com'
      }
    end

    let(:invalid_attributes) do
      {
        first_name: '',
        last_name: 'User',
        email: 'invalid'
      }
    end

    it 'creates a user with valid attributes' do
      expect {
        post '/api/v1/users', params: valid_attributes
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns error with invalid attributes' do
      post '/api/v1/users', params: invalid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key('errors')
    end
  end
end