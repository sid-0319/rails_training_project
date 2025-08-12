FactoryBot.define do
  factory :restaurant_table do
    table_number { Faker::Number.between(from: 1, to: 20) }
    seats { Faker::Number.between(from: 1, to: 8) }
    status { %i[available occupied reserved].sample }
    association :restaurant
  end
end
