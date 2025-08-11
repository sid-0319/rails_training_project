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

      # Additional valid param cases
      it 'allows rating at minimum value (1)' do
        post feedbacks_path, params: valid_params.deep_merge(feedback: { rating: 1 })
        expect(Feedback.last.rating).to eq(1)
      end

      it 'allows rating at maximum value (5)' do
        post feedbacks_path, params: valid_params.deep_merge(feedback: { rating: 5 })
        expect(Feedback.last.rating).to eq(5)
      end

      it 'allows feedback without restaurant_id (general feedback)' do
        post feedbacks_path, params: valid_params.deep_merge(feedback: { restaurant_id: nil })
        expect(Feedback.last.restaurant_id).to be_nil
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

      # Additional invalid param cases
      it 'rejects rating below minimum' do
        post feedbacks_path, params: invalid_params.deep_merge(feedback: { rating: 0, comment: 'Bad' })
        expect(response.body).to include('must be greater than or equal to 1')
      end

      it 'rejects rating above maximum' do
        post feedbacks_path, params: invalid_params.deep_merge(feedback: { rating: 6, comment: 'Too good' })
        expect(response.body).to include('must be less than or equal to 5')
      end

      it 'rejects feedback without comment' do
        post feedbacks_path, params: invalid_params.deep_merge(feedback: { rating: 3 })
        expect(response.body).to include('can&#39;t be blank')
      end
    end

    # Additional behavior cases
    it 'requires user to be logged in' do
      logout(:user)
      post feedbacks_path, params: {
        feedback: {
          restaurant_id: restaurant.id,
          rating: 4,
          comment: 'Test'
        }
      }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'sets created_at timestamp upon creation' do
      post feedbacks_path, params: {
        feedback: {
          restaurant_id: restaurant.id,
          current_url: "/restaurants/#{restaurant.id}",
          rating: 5,
          comment: 'Time check'
        }
      }
      expect(Feedback.last.created_at).not_to be_nil
    end

    it 'associates feedback with correct restaurant if provided' do
      post feedbacks_path, params: {
        feedback: {
          restaurant_id: restaurant.id,
          rating: 4,
          comment: 'Linked to restaurant'
        }
      }
      expect(Feedback.last.restaurant).to eq(restaurant)
    end

    it 'redirects back to current_url after submission if provided' do
      post feedbacks_path, params: {
        feedback: {
          restaurant_id: restaurant.id,
          current_url: "/restaurants/#{restaurant.id}",
          rating: 4,
          comment: 'Redirect test'
        }
      }
      expect(response).to redirect_to("/restaurants/#{restaurant.id}")
    end
  end
end
