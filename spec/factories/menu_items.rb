FactoryBot.define do
  factory :restaurant do
    name { 'Test Restaurant' }
  end

  factory :menu_item do
    item_name { 'Sample Dish' }
    description { 'A tasty sample dish.' }
    price { 9.99 }
    category { 'Main Course' }
    available { true }
    association :restaurant
  end
end
