class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant, if: -> { params[:restaurant_id].present? }
  before_action :set_order, only: %i[edit update destroy]
  before_action :set_reservation, if: -> { params[:reservation_id].present? }

  # List all orders for current user & restaurant (if restaurant present)
  def index
    @orders = if @restaurant
                current_user.orders.where(restaurant: @restaurant).order(created_at: :desc)
              else
                current_user.orders.order(created_at: :desc)
              end
  end

  # Show form to create a new order (optional if using modal or inline)
  def new
    @order = current_user.orders.new(restaurant: @restaurant)
  end

  # Create order with submitted data
  def create
    @order = current_user.orders.new(order_params.except(:items))

    # Parse items JSON string into array of hashes
    @order.items = begin
      JSON.parse(order_params[:items] || '[]')
    rescue StandardError
      []
    end

    @order.restaurant = @restaurant if @restaurant
    @order.reservation = @reservation if @reservation

    if params[:reservation_id]
      @reservation = Reservation.find(params[:reservation_id])
      @order.restaurant_table_id = @reservation.restaurant_table_id
    end

    # Assign customer_name from current user
    @order.customer_name = "#{current_user.first_name} #{current_user.last_name}".strip

    @order.order_number = SecureRandom.hex(8)
    @order.status = :pending
    @order.total_price = @order.calculate_total_price

    if @order.save
      redirect_to restaurant_reservation_orders_path(@restaurant, @reservation), notice: 'Order placed successfully.'
    else
      # Redirect back with error messages (no new template needed)
      redirect_back fallback_location: restaurant_menu_path(@restaurant), alert: @order.errors.full_messages.join(', ')
    end
  end

  # Show form to edit an order
  def edit
  end

  # Update order data
  def update
    @order.assign_attributes(order_params.except(:items))
    @order.items = begin
      JSON.parse(order_params[:items] || '[]')
    rescue StandardError
      []
    end

    @order.total_price = @order.calculate_total_price

    if @order.save
      redirect_to restaurant_orders_path(@restaurant), notice: 'Order updated successfully.'
    else
      render :edit
    end
  end

  # Delete an order
  def destroy
    @order.destroy
    redirect_to restaurant_orders_path(@restaurant), notice: 'Order deleted successfully.'
  end

  # Optional: List all orders for current user across all restaurants
  def my_orders
    @orders = current_user.orders.order(created_at: :desc)
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_order
    # find order scoped to current user
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_name, :items)
  end
end
