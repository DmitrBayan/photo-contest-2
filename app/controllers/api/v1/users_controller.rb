module Api
  module V1
    class UsersController < ::Api::ApiController
      layout false
      before_action :verify_authenticity_token

      def index
        @users = User.by_full_name(params[:search])
                     .paginate(page: params[:page])
        render json: @users, status: :ok
      end

      def show
        @user = User.find(params[:id])
        @posts = @user.posts
        render json: @user, status: :ok
      end

      def destroy
        user = User.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == user.id

        user.destroy
        render json: { message: 'removed' }, status: :ok
      end

      def update
        @user = @api_user
        @user.update(user_params)
        validate @user
      end

      def edit
        @user = @api_user
      end
      
      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :image_url)
      end
    end
  end
end