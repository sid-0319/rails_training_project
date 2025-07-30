FactoryBot.define do
  factory :restaurant_table do
    table_number { 1 }
    seats { 1 }
    status { 1 }
    restaurant { nil }
  end
end
