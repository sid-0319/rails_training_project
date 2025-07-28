class AddAasmStateToRestaurants < ActiveRecord::Migration[8.0]
  def change
    add_column :restaurants, :aasm_state, :string
  end
end
