# frozen_string_literal: true

# User Class
class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, :phone_number, presence: true
  validates :email, uniqueness: true
end
