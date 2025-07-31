class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def index
    # Render the default view — all role-specific logic is handled in the view
  end

  private

  def authorize_user
    case current_user.role_type
    when 'admin'
      # allow access
    when 'staff'
      # allow access or redirect_to staff_dashboard_path
    when 'customer'
      # allow access or redirect_to customer_dashboard_path
    else
      redirect_to root_path, alert: 'Unauthorized access'
    end
  end
end
