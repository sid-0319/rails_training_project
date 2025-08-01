class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :item_name
      t.text :description
      t.decimal :price
      t.string :category
      t.boolean :available
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
