class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.jsonb :items, default: [], null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.string :customer_name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.references :restaurant_table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
