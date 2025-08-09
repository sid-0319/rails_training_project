class Restaurant < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :restaurant_tables, class_name: 'RestaurantTable', foreign_key: 'restaurant_id'
  has_many :menu_items, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :feedbacks

  validates :name, :description, :location, :cuisine_type, presence: true

  aasm column: :status do
    state :open, initial: true
    state :closed
    state :archived
  end
end
