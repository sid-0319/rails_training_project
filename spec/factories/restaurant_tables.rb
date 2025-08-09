# spec/factories/users.rb
FactoryBot.define do
  factory :restaurant_table do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    password   { 'password123' }
    password_confirmation { 'password123' }
    age { Faker::Number.between(from: 18, to: 65) }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    role_type { :staff }
    account_status { :active }

    trait :staff do
      role_type { :staff }
    end

    trait :customer do
      role_type { :customer }
    end
  end
end
