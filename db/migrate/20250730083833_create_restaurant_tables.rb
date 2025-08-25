class CreateRestaurantTables < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurant_tables do |t|
      t.integer :table_number
      t.integer :seats
      t.integer :status
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
