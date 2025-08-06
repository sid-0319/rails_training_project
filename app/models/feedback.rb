class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant, optional: true

  validates :rating, presence: true, inclusion: 1..5
  validates :comment, presence: true
end
