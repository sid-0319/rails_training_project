class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :restaurant_table
  belongs_to :reservation

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :order_number, presence: true, uniqueness: true
  validates :customer_name, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :items, presence: true

  def calculate_total_price
    return 0 if items.blank?

    items.sum { |item| item['price'].to_f * item['quantity'].to_i }
  end
end
