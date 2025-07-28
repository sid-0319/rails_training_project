# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, :phone_number, presence: true
  validates :email, uniqueness: true

  has_one_attached :avatar
  has_many :restaurants, dependent: :destroy

  validate :avatar_validation

  private

  def avatar_validation
    return unless avatar.attached?

    errors.add(:avatar, 'is too big. Max size is 10MB.') if avatar.blob.byte_size > 10.megabytes

    acceptable_types = ['image/jpeg', 'image/png']
    errors.add(:avatar, 'must be JPEG or PNG.') unless acceptable_types.include?(avatar.content_type)

    # Validate dimensions
    begin
      file = ActiveStorage::Blob.service.send(:path_for, avatar.key)
      dimensions = FastImage.size(file)

      if dimensions
        width, height = dimensions
        errors.add(:avatar, 'dimensions should not exceed 1600x1200.') if width > 1600 || height > 1200
      end
    rescue StandardError => e
      Rails.logger.error "FastImage error: #{e.message}"
      errors.add(:avatar, 'could not be validated for dimensions.')
    end
  end
end
