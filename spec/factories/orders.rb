FactoryBot.define do
  factory :order do
    order_number { "MyString" }
    items { "" }
    total_price { "9.99" }
    status { 1 }
    customer_name { "MyString" }
    user { nil }
    restaurant { nil }
    restaurant_table { nil }
  end
end
