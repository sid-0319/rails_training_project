class ReservationMailer < ApplicationMailer
  def confirmation_email(reservation)
    @reservation = reservation
    mail(
      to: @reservation.customer_email,
      subject: "Reservation Confirmed at #{@reservation.restaurant.name}"
    )
  end

  def rejection_email(reservation)
    @reservation = reservation
    mail(
      to: @reservation.customer_email,
      subject: "Reservation Rejected at #{@reservation.restaurant.name}"
    )
  end
end
