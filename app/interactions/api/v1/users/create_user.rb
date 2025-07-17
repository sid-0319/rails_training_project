module Api
  module V1
    module Users
      class CreateUser < ActiveInteraction::Base
        string :first_name, :last_name, :email, :phone_number, :password, :password_confirmation
        integer :age
        date :date_of_birth

        validates :password, confirmation: true
        validates :password_confirmation, presence: true

        def execute
          user = User.new(
            first_name: first_name,
            last_name: last_name,
            email: email,
            phone_number: phone_number,
            password: password,
            password_confirmation: password_confirmation,
            age: age,
            date_of_birth: date_of_birth
          )

          unless user.save
            errors.merge!(user.errors)
            return nil
          end

          user
        end
      end
    end
  end
end
