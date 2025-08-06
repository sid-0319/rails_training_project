FactoryBot.define do
  factory :feedback do
    rating { 4 }
    comment { 'Great experience!' }
    current_url { 'http://example.com/restaurant/247' }
    association :user
    association :restaurant
  end
end
