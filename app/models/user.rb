# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, :phone_number, presence: true
  validates :email, uniqueness: true

  has_one_attached :avatar

  validate :avatar_validation

private

def avatar_validation
  return unless avatar.attached?

  if avatar.blob.byte_size > 10.megabytes
    errors.add(:avatar, 'is too big. Max size is 10MB.')
  end

  acceptable_types = ["image/jpeg", "image/png"]
  unless acceptable_types.include?(avatar.content_type)
    errors.add(:avatar, 'must be JPEG or PNG.')
  end

  # Validate dimensions
 begin
    file = ActiveStorage::Blob.service.send(:path_for, avatar.key)
    dimensions = FastImage.size(file)

    if dimensions
      width, height = dimensions
      if width > 1600 || height > 1200
        errors.add(:avatar, 'dimensions should not exceed 1600x1200.')
      end
    end
  rescue => e
    Rails.logger.error "FastImage error: #{e.message}"
    errors.add(:avatar, 'could not be validated for dimensions.')
  end
end
end
