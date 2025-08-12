FactoryBot.define do
  factory :token do
    value { SecureRandom.hex(32) }
    expired_at { 24.hours.from_now }
  end
end
