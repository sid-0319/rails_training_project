# app/controllers/restaurant_tables_controller.rb
class RestaurantTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_staff!
  before_action :set_restaurant
  before_action :set_table, only: %i[edit update destroy]

  helper_method :sort_column, :sort_direction

  def index
    Rails.logger.info "Restaurant ID: #{params[:restaurant_id]}"
    @status_filter = params[:status]

    @tables = @restaurant.restaurant_tables
    @tables = @tables.where(status: @status_filter) if @status_filter.present?
    @tables = @tables.order("#{sort_column} #{sort_direction}")
                     .paginate(page: params[:page], per_page: 5)
  end

  def new
    @table = @restaurant.restaurant_tables.new
  end

  def create
    @table = @restaurant.restaurant_tables.new(table_params)
    if @table.save
      redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @table.update(table_params)
      redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @table.destroy
    redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table deleted.'
  end

  private

  def require_staff!
    redirect_to root_path, alert: 'Access denied.' unless current_user.staff?
  end

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
    redirect_to restaurants_path, alert: 'Restaurant not found.' unless @restaurant
  end

  def set_table
    @table = @restaurant.tables.find_by(id: params[:id])
    redirect_to restaurant_restaurant_tables_path(@restaurant), alert: 'Table not found.' unless @table
  end

  def table_params
    params.require(:restaurant_table).permit(:table_number, :seats, :status)
  end

  def sort_column
    %w[table_number seats status created_at].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
