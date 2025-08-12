class AddCustomerNameToFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_column :feedbacks, :customer_name, :string
  end
end
