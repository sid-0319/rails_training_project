class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_requested_role, if: -> { devise_controller? && params[:role].present? }
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

  def after_sign_in_path_for(resource)
    role = session[:login_role]

    case role
    when 'staff'
      if resource.role_type == 'staff'
        root_path
      else
        flash[:alert] = 'You are not authorized to log in as staff.'
        flash.delete(:notice)
        sign_out(resource)
        new_user_session_path(role: 'staff')
      end
    when 'customer'
      if resource.role_type == 'customer'
        root_path
      else
        flash[:alert] = 'You are not authorized to log in as customer.'
        flash.delete(:notice)
        sign_out(resource)
        new_user_session_path(role: 'customer')
      end
    else
      root_path
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  def store_requested_role
    session[:login_role] = params[:role]
  end

  def authenticate_admin_if_api!
    return unless request.path.start_with?('/api/')

    authenticate_admin!
  end

  def authenticate_admin!
    token_value = request.headers['Authorization']
    render json: { error: 'Unauthorized: Missing token' }, status: :unauthorized and return if token_value.blank?

    token = Token.find_by(value: token_value)
    return unless token.nil? || token.expired_at < Time.current

    render json: { error: 'Unauthorized: Invalid or expired token' }, status: :unauthorized and return
  end
end
