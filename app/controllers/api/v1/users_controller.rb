module Api
  module V1
    class UsersController < ::Api::ApiController
      def index
        users = User.by_full_name(params[:search])
                     .paginate(page: params[:page])
        render json: users, status: :ok
      end

      def show
        user = User.find(params[:id])
        render json: user, status: :ok
      end

      def destroy
        user = User.find(params[:id])
        validate_user user

        user.destroy
        render json: { message: 'removed' }, status: :ok
      end

      def update
        user = User.find(params[:id])
        validate_user user

        if user.update(user_params)
          render json: user, status: :ok
        else
          render json: {errors: user.errors}, status: :unprocessable_entity
        end
      end
      
      private

      def user_params
        params.permit(:first_name, :last_name, :image_url, :email)
      end
    end
  end
end