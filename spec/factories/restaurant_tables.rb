FactoryBot.define do
  factory :restaurant_table, class: 'Table' do
    table_number { Faker::Number.unique.number(digits: 2) }
    seats { rand(2..6) }
    status { %i[available reserved occupied].sample }
    association :restaurant
  end
end
