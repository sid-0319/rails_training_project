# app/models/reservation.rb

class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :restaurant_table
  has_many :orders, dependent: :destroy
  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates :reservation_date, :reservation_time, :number_of_guests, :customer_name, :customer_contact, presence: true
  validate :no_double_booking

  validate :reservation_date_cannot_be_in_the_past

  private

  def reservation_date_cannot_be_in_the_past
    return if reservation_date.blank?

    return unless reservation_date < Date.current

    errors.add(:reservation_date, "can't be in the past")
  end

  def no_double_booking
    return unless restaurant

    if restaurant.reservations.where(reservation_date: reservation_date,
                                     reservation_time: reservation_time).where.not(id: id).exists?
      errors.add(:base, 'Table is already booked for the selected time')
    end
  end
end
