class RestaurantTable < ApplicationRecord
  belongs_to :restaurant

  enum :status, { available: 0, reserved: 1, occupied: 2 }
  validates :table_number, :seats, :status, presence: true
end
