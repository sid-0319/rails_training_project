class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer!
  before_action :set_reservation
  before_action :set_restaurant

  def new
    @reservation = Reservation.find(params[:reservation_id])
    @order = @reservation.orders.build
    @menu_items = @restaurant.menu_items.where(available: true)
  end

  def create
    @order = @reservation.orders.build(order_params)
    if @order.save
      redirect_to restaurant_path(@restaurant), notice: 'Order placed successfully!'
    else
      @menu_items = @restaurant.menu_items.where(available: true)
      render :new
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def order_params
    params.require(:order).permit(:menu_item_id, :quantity)
  end

  def require_customer!
    redirect_to root_path unless current_user.customer?
  end
end
