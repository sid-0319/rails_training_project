class ChangeTableNumberToStringInRestaurantTables < ActiveRecord::Migration[8.0]
  def change
    change_column :restaurant_tables, :table_number, :string
  end
end
