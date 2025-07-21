module Api
  module V1
    class UsersController < ApplicationController

      def_param_group :user do
        property :id, Integer, desc: 'User ID'
        property :first_name, String, desc: 'First name'
        property :last_name, String, desc: 'Last name'
        property :email, String, desc: 'Email'
        property :created_at, String, desc: 'Created at: '
      end

      api :GET, '/api/v1/users', 'GET REQUEST - Retrieves all Users'
      returns array_of: :user, code: 200, desc: 'List of All Users'
      def index
        users = User.all
        render json: users, each_serializer: UserSerializer
      end
    end
  end
end