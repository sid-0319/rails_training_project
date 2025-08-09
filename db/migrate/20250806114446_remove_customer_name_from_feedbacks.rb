class RemoveCustomerNameFromFeedbacks < ActiveRecord::Migration[8.0]
  def change
    remove_column :feedbacks, :customer_name, :string
  end
end
