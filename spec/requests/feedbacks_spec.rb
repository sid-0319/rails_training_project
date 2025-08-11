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
  end
end
