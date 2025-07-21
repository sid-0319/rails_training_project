class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.text :value, null: false
      t.datetime :expired_at, null: false
      t.timestamps
    end

    add_index :tokens, :value, unique: true
  end
end