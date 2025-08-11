class AddUserToReservations < ActiveRecord::Migration[8.0]
  def change
    add_reference :reservations, :user, null: true, foreign_key: true
  end
end
