class MenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_menu_item, only: %i[edit update destroy]

  def index
    @menu_items = @restaurant.menu_items.order(:category, :item_name)
    @reservation = current_user.reservations
                               .where(restaurant: @restaurant)
                               .where(status: %w[pending accepted])
                               .order(reservation_date: :asc, reservation_time: :asc)
                               .first
  end

  def new
    @menu_item = @restaurant.menu_items.new
  end

  def create
    @menu_item = @restaurant.menu_items.new(menu_item_params)
    if @menu_item.save
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item deleted.'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = @restaurant.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:item_name, :description, :price, :category, :available, :is_vegetarian)
  end
end
