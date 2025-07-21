class Token < ApplicationRecord
  before_create :generate_value_and_expiration

  private

  def generate_value_and_expiration
    self.value = SecureRandom.hex(32)
    self.expired_at = 24.hours.from_now
  end
end