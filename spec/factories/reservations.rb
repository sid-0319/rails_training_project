FactoryBot.define do
  factory :reservation do
    reservation_date { "2025-08-05" }
    reservation_time { "2025-08-05 04:39:05" }
    number_of_guests { 1 }
    customer_name { "MyString" }
    customer_contact { "MyString" }
    restaurant { nil }
  end
end
