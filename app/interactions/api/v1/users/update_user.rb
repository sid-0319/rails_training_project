module Api
  module V1
    module Users
      class UpdateUser < ActiveInteraction::Base
        integer :id
        string :first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :date_of_birth, default: nil
        integer :age, default: nil

        validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
        validates :password, confirmation: true, if: -> { password.present? }

        def execute
          user = User.find_by(id: id)
          errors.add(:user, 'not found') and return unless user

          user.assign_attributes(inputs.except(:id).compact)
          unless user.save
            errors.merge!(user.errors)
            return
          end

          user
        end
      end
    end
  end
end