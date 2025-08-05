class AddCustomerEmailToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :customer_email, :string
  end
end
