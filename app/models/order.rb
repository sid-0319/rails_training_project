class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :restaurant_table
  belongs_to :reservation

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates :order_number, :items, :total_price, :status, :customer_name, presence: true
end
