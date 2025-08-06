class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.includes(:user, :restaurant).all
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = current_user if user_signed_in?
    @feedback.customer_name = current_user.first_name

    if params[:restaurant_id].present?
      @restaurant = Restaurant.find_by(id: params[:restaurant_id])
      @feedback.restaurant = @restaurant if @restaurant
    else
      @restaurant = nil
    end

    if @feedback.save
      redirect_to request.referer || root_path, notice: 'Feedback submitted successfully.'
    else
      @feedbacks = Feedback.includes(:user, :restaurant).all
      flash.now[:alert] = 'Failed to submit feedback.'
      render :index
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:rating, :comment, :restaurant_id, :current_url)
  end
end
