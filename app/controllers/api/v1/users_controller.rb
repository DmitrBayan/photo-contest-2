module Api
  module V1
    class UsersController < ::Api::ApiController
      layout false
      before_action :verify_authenticity_token

      def index
        users = User.by_full_name(params[:search])
                     .paginate(page: params[:page])
        render json: users, status: :ok
      end

      def show
        user = User.find(params[:id])
        posts = user.posts
        render json: user, status: :ok
      end

      def destroy
        user = User.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == user.id

        user.destroy
        render json: { message: 'removed' }, status: :ok
      end

      def update
        if @api_user.update(user_params)
          render json: @api_user, status: :ok
        else
          render json: {errors: @api_user.errors}, status: :unprocessable_entity
        end
      end
      
      private

      def user_params
        params.permit(:first_name, :last_name, :image_url)
      end
    end
  end
end