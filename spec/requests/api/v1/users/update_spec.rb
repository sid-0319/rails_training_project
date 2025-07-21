require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/:id', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  it 'updates the user successfully' do
    put "/api/v1/users/#{user.id}", params: { first_name: 'Updated' }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['first_name']).to eq('Updated')
  end

  it 'returns 404 if user not found' do
    put '/api/v1/users/99999', params: { first_name: 'Updated' }
    expect(response).to have_http_status(:not_found)
  end

  it 'returns 422 if update is invalid' do
    put "/api/v1/users/#{user.id}", params: { email: 'invalid-email' }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'updates only one attribute' do
    original_email = user.email
    put "/api/v1/users/#{user.id}", params: { last_name: 'Solo' }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['last_name']).to eq('Solo')
    expect(User.find(user.id).email).to eq(original_email)
  end
end