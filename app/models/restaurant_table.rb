class RestaurantTable < ApplicationRecord
  belongs_to :restaurant
  has_many :reservations, dependent: :destroy

  enum :status, { available: 0, reserved: 1, occupied: 2 }

  validates :table_number, :seats, :status, presence: true
  validates :seats, numericality: { greater_than_or_equal_to: 1, message: 'must be at least 1' }
end
