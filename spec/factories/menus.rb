FactoryBot.define do
  factory :menu_item do
    item_name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 5.0..50.0) }
    category { Faker::Food.ethnic_category }
    available { [true, false].sample }
    is_vegetarian { [true, false].sample }
    association :restaurant
  end
end
