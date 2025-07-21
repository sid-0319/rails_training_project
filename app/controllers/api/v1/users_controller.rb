module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      extend Apipie::DSL::Concern

      def_param_group :user do
        property :id, Integer, desc: 'User ID'
        property :first_name, String, desc: 'Users First name'
        property :last_name, String, desc: 'Users Last name'
        property :email, String, desc: 'Users Email'
        property :phone_number, String, desc: 'Users Phone Number'
        property :age, Integer, desc: 'Users Age'
        property :date_of_birth, String, desc: 'Users Date of Birth (YYYY-MM-DD)'
        property :created_at, String, desc: 'Created at'
      end

      api :GET, '/api/v1/users', 'GET REQUEST - Retrieves all Users'
      returns array_of: :user, code: 200, desc: 'List of All Users'
      def index
        users = User.all
        render json: users, each_serializer: UserSerializer
      end

      api :POST, '/api/v1/users', 'POST REQUEST - Create a new User'
      param :first_name, String, required: true, desc: 'Users First name'
      param :last_name, String, required: true, desc: 'Users Last name'
      param :email, String, required: true, desc: 'Users Email address'
      param :phone_number, String, required: true, desc: 'Users Phone Number'
      param :password, String, required: true, desc: 'Users Password'
      param :password_confirmation, String, required: true, desc: 'Users Password confirmation'
      param :age, Integer, required: true, desc: 'Users Age'
      param :date_of_birth, String, required: true, desc: 'Users Date of birth (YYYY-MM-DD)'
      returns code: 201, desc: 'User created successfully', param_group: :user
      returns code: 422, desc: 'Validation failed'
      def create
        result = ::Api::V1::Users::CreateUser.run(user_params)

        if result.valid?
          render json: result.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(
          :first_name, :last_name, :email,
          :phone_number, :password, :password_confirmation,
          :age, :date_of_birth
        )
      end
    end
  end
end
