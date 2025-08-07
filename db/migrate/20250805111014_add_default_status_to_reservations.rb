class AddDefaultStatusToReservations < ActiveRecord::Migration[8.0]
  def change
    change_column_default :reservations, :status, 0
  end
end
