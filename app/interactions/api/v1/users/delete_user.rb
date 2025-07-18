module Api
  module V1
    module Users
      class DeleteUser < ActiveInteraction::Base
        integer :id

        def execute
          user = User.find_by(id: id)
          errors.add(:base, 'User not found') and return unless user

          user.destroy
        end
      end
    end
  end
end