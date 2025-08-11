class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant, except: [:index]
  before_action :set_reservation, only: %i[update accept reject]
  before_action :require_staff!, only: %i[table_index accept reject]

  def my_reservations
    @reservations = current_user.reservations.includes(:restaurant)
  end

  def new
    @reservation = @restaurant.reservations.new(restaurant_table_id: params[:restaurant_table_id])
  end

  def create
    @reservation = @restaurant.reservations.new(reservation_params)
    @reservation.user = current_user # ✅ Link reservation to logged-in customer

    if @reservation.save
      redirect_to root_path, notice: 'Reservation is under progress!.'
    else
      render :new
    end
  end

  def table_index
    @table = @restaurant.restaurant_tables.find(params[:restaurant_table_id])
    @reservations = @table.reservations.order(reservation_date: :asc, reservation_time: :asc)
    render :index
  end

  def update
    if @reservation.update(reservation_status_params)
      redirect_to restaurant_reservations_path(@restaurant), notice: 'Reservation status updated successfully.'
    else
      redirect_to restaurant_reservations_path(@restaurant), alert: 'Failed to update reservation status.'
    end
  end

  def index
    if params[:restaurant_id] && current_user&.staff?
      # Staff viewing reservations for a specific restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
      @reservations = @restaurant.reservations
                                 .order(reservation_date: :asc, reservation_time: :asc)
    else
      # Customer viewing all their reservations
      @reservations = current_user.reservations
                                  .includes(:restaurant)
                                  .order(reservation_date: :asc, reservation_time: :asc)
    end
  end

  # Staff action to confirm a reservation
  def accept
    if @reservation.pending?
      @reservation.accepted!
      @reservation.restaurant_table.update(status: :reserved)
      ReservationMailer.confirmation_email(@reservation).deliver_now
      redirect_to restaurant_reservations_path(@reservation.restaurant), notice: 'Reservation confirmed.'
    else
      redirect_to restaurant_reservations_path(@reservation.restaurant),
                  alert: 'Reservation cannot be confirmed as it is not pending.'
    end
  end

  # Staff action to reject a reservation
  def reject
    if @reservation.pending? || @reservation.accepted?
      @reservation.rejected!
      @reservation.restaurant_table.update(status: :available)
      ReservationMailer.rejection_email(@reservation).deliver_now
      redirect_to restaurant_reservations_path(@reservation.restaurant),
                  notice: 'Reservation rejected and table made available.'
    else
      redirect_to restaurant_reservations_path(@reservation.restaurant),
                  alert: 'Reservation cannot be rejected from its current state.'
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_reservation
    @reservation = @restaurant.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:reservation_date, :reservation_time, :number_of_guests, :customer_name,
                                        :customer_contact, :restaurant_table_id, :customer_email)
  end
end
