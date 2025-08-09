class AddReservationToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :reservation, null: false, foreign_key: true
  end
end
