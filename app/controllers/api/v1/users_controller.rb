module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      extend Apipie::DSL::Concern

      def_param_group :user do
        property :id, String, desc: 'User ID'
        property :first_name, String, desc: 'First name'
        property :last_name, String, desc: 'Last name'
        property :email, String, desc: 'Email'
        property :phone_number, String, desc: 'Phone Number'
        property :age, Integer, desc: 'Age'
        property :date_of_birth, String, desc: 'Date of Birth (YYYY-MM-DD)'
        property :created_at, String, desc: 'Created at'
      end

      api :GET, '/api/v1/users', 'GET REQUEST - Retrieves all Users'
      returns array_of: :user, code: 200, desc: 'List of All Users'
      def index
        users = User.all
        render json: users, each_serializer: UserSerializer
      end

      api :POST, '/api/v1/users', 'POST REQUEST - Create a new User'
      param :first_name, String, required: true, desc: 'First name'
      param :last_name, String, required: true, desc: 'Last name'
      param :email, String, required: true, desc: 'Email address'
      param :phone_number, String, required: true, desc: 'Phone Number'
      param :password, String, required: true, desc: 'Password'
      param :password_confirmation, String, required: true, desc: 'Password confirmation'
      param :age, Integer, required: true, desc: 'Age'
      param :date_of_birth, String, required: true, desc: 'Date of birth (YYYY-MM-DD)'
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

      api :GET, '/api/v1/users/:id', 'GET REQUEST - Retrieve a specific user by ID'
      param :id, String, required: true, desc: 'User ID'
      returns code: 200, desc: 'User found', param_group: :user
      returns code: 404, desc: 'User not found'
      def show
        user = User.find_by(id: params[:id])

        if user
          render json: user, serializer: UserSerializer, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      api :PUT, '/api/v1/users/:id', 'PUT REQUEST - Update a User'
      param :id, String, required: true, desc: 'User ID'
      param :first_name, String, desc: 'First name'
      param :last_name, String, desc: 'Last name'
      param :email, String, desc: 'Email address'
      param :phone_number, String, desc: 'Phone Number'
      param :password, String, desc: 'Password'
      param :password_confirmation, String, desc: 'Password confirmation'
      param :age, Integer, desc: 'Age'
      param :date_of_birth, String, desc: 'Date of birth (YYYY-MM-DD)'
      returns code: 200, desc: 'User updated successfully', param_group: :user
      returns code: 404, desc: 'User not found'
      returns code: 422, desc: 'Validation failed'
      def update
        result = ::Api::V1::Users::UpdateUser.run(user_params.merge(id: params[:id]))

        if result.valid?
          render json: result.result, serializer: UserSerializer
        else
          if result.errors.details[:user]&.any? { |e| e[:error] == :invalid } || result.errors.full_messages.include?('User not found')
            render json: { errors: result.errors.full_messages }, status: :not_found
          else
            render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
          end
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
