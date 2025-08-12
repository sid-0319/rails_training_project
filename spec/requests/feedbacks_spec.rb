require 'rails_helper'
include Rails.application.routes.url_helpers

RSpec.describe 'Feedbacks', type: :request do
  let(:user) { create(:user, role_type: :customer) }
  let(:restaurant) { create(:restaurant) }

  before do
    login_as(user, scope: :user)
  end

  describe 'POST /feedbacks' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          feedback: {
            restaurant_id: restaurant.id,
            current_url: "/restaurants/#{restaurant.id}",
            rating: 5,
            comment: 'Great experience!'
          }
        }
      end

      it 'creates new feedback and associates it with current user' do
        expect do
          post feedbacks_path, params: valid_params
        end.to change(Feedback, :count).by(1)

        feedback = Feedback.last
        expect(feedback.user_id).to eq(user.id)
        expect(feedback.restaurant_id).to eq(restaurant.id)
        expect(feedback.comment).to eq('Great experience!')

        expect(response).to redirect_to(restaurants_path)
        follow_redirect!
        expect(response.body).to include('Feedback submitted')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          feedback: {
            restaurant_id: nil,
            rating: nil,
            comment: ''
          }
        }
      end

      it 'does not create feedback and shows error messages' do
        expect do
          post feedbacks_path, params: invalid_params
        end.not_to change(Feedback, :count)

        expect(response.body).to include('can&#39;t be blank')
      end
    end

    context 'with missing rating' do
      it 'rejects feedback without rating' do
        params = {
          feedback: {
            restaurant_id: restaurant.id,
            comment: 'Food was ok',
            rating: nil
          }
        }
        post feedbacks_path, params: params
        expect(response.body).to include('Rating can&#39;t be blank')
      end
    end

    context 'with invalid rating value' do
      it 'rejects rating outside allowed range' do
        params = {
          feedback: {
            restaurant_id: restaurant.id,
            comment: 'Too bad!',
            rating: 10
          }
        }
        post feedbacks_path, params: params
        expect(response.body).to include('Rating is not included in the list')
      end
    end

    context 'with empty comment' do
      it 'rejects feedback without comment' do
        params = {
          feedback: {
            restaurant_id: restaurant.id,
            rating: 3,
            comment: ''
          }
        }
        post feedbacks_path, params: params
        expect(response.body).to include('Comment can&#39;t be blank')
      end
    end

    context 'with excessively long comment' do
      it 'rejects feedback exceeding character limit' do
        params = {
          feedback: {
            restaurant_id: restaurant.id,
            rating: 4,
            comment: 'A' * 1001
          }
        }
        post feedbacks_path, params: params
        expect(response.body).to include('Comment is too long')
      end
    end
  end

  it 'GET /restaurants page is accessible after login' do
    get restaurants_path
    expect(response).to have_http_status(:ok)
  end

  it 'valid feedback increases Feedback count' do
    expect do
      post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 4, comment: 'Nice' } }
    end.to change(Feedback, :count).by(1)
  end

  it 'Feedback count does not change with invalid params' do
    expect do
      post feedbacks_path, params: { feedback: { restaurant_id: nil, rating: nil, comment: '' } }
    end.not_to change(Feedback, :count)
  end

  it 'redirects to restaurants_path after successful feedback' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 5, comment: 'Perfect' } }
    expect(response).to redirect_to(restaurants_path)
  end

  it 'renders error when posting without restaurant_id' do
    post feedbacks_path, params: { feedback: { rating: 5, comment: 'Oops' } }
    expect(response.body).to include('can&#39;t be blank')
  end

  it 'allows rating in allowed range' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 1, comment: 'Low but valid' } }
    expect(response).to have_http_status(:found).or have_http_status(:redirect)
  end

  it 'feedback comment text is saved correctly' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 5, comment: 'Memorable visit' } }
    expect(Feedback.last.comment).to eq('Memorable visit')
  end

  it 'feedback belongs to the correct restaurant' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 3, comment: 'Alright' } }
    expect(Feedback.last.restaurant_id).to eq(restaurant.id)
  end

  it 'feedback belongs to the current user' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 2, comment: 'Could improve' } }
    expect(Feedback.last.user_id).to eq(user.id)
  end

  it 'feedback rating is stored as integer' do
    post feedbacks_path, params: { feedback: { restaurant_id: restaurant.id, rating: 4, comment: 'Solid choice' } }
    expect(Feedback.last.rating).to be_a(Integer)
  end
end
