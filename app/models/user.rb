# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ✅ Add these validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :age, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
end
