# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    age { rand(1..99) }
    date_of_birth { Faker::Date.birthday(min_age: 1, max_age: 99) }
    phone_number { Faker::PhoneNumber.cell_phone }
    password { 'Password@123' }
    password_confirmation { 'Password@123' }
  end
end
