
class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin_if_api!

  protected

  def configure_permitted_parameters
    added_attrs = %i[
      first_name last_name age date_of_birth phone_number
      email password password_confirmation
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def authenticate_admin_if_api!
    return unless request.path.start_with?('/api/')

    authenticate_admin!
  end

  def authenticate_admin!
    token_value = request.headers['Authorization']

    if token_value.blank?
      render json: { error: 'Unauthorized: Missing token' }, status: :unauthorized and return
    end

    token = Token.find_by(value: token_value)

    if token.nil? || token.expired_at < Time.current
      render json: { error: 'Unauthorized: Invalid or expired token' }, status: :unauthorized and return
    end
  end
end
