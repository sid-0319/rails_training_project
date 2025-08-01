class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def index
    # View will render role-specific UI
  end

  private

  def authorize_user
    case current_user.role_type
    when 'admin'
      # Allow access
    when 'staff'
      # Allow or redirect_to staff_dashboard_path
    when 'customer'
      # Allow or redirect_to customer_dashboard_path
    else
      redirect_to root_path, alert: 'Unauthorized access'
    end
  end

  def role_param
    params[:role] || session[:login_role]
  end
end
