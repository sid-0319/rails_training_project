class AddIsVegetarianToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :is_vegetarian, :boolean
  end
end
