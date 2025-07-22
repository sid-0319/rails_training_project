module Api
  module V1
    class UsersQuery
      def initialize(params)
        @params = params
      end

      def call
        scope = User.all
        scope = scope.where('first_name ILIKE ?', "%#{@params[:first_name]}%") if @params[:first_name].present?
        scope = scope.where('last_name ILIKE ?', "%#{@params[:last_name]}%") if @params[:last_name].present?
        scope = scope.where('email ILIKE ?', "%#{@params[:email]}%") if @params[:email].present?
        scope.order(:created_at)
      end
    end
  end
end