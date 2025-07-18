require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/:id', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  context 'when user exists' do
    it 'deletes the user successfully' do
      delete "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('User deleted successfully')
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  context 'when user does not exist' do
    it 'returns 404 for non-existent user' do
      delete '/api/v1/users/999999'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to include('User not found')
    end
  end

  context 'when id is invalid' do
    it 'returns 404 for negative ID' do
      delete '/api/v1/users/-1'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to include('User not found')
    end

    it 'returns 404 for non-integer ID' do
      delete '/api/v1/users/abc'

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'after deletion' do
    it 'cannot delete same user twice' do
      delete "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)

      delete "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:not_found)
    end
  end
end