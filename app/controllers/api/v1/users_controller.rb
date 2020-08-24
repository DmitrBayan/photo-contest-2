module Api
  module V1
    class UsersController < ::Api::ApiController
      layout false
      before_action :verify_authenticate_token

      def index
        @users = User.by_full_name(params[:search])
                     .paginate(page: params[:page])
        render json: @users, status: :ok
      end

      def show
        @user = User.find(params[:id])
        @posts = if @user.eql?(current_user)
                   params[:filter].present? ? @user.posts.by_state(params[:filter]) : @user.posts
                 else
                   @user.posts.approved
                 end
        render json: @user, status: :ok
      end

      def destroy
        user = User.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == user.id

        user.destroy
        render json: { message: 'removed' }, status: :ok
      end

      def current
        raise ::Errors::InvalidRequestData unless @api_user

        render json: @api_user, user_id: @api_user.id, status: :ok
      end

      def posts
        user = User.find(params[:id])
        raise ::Errors::InvalidRequestData unless user

        posts = Post.where(user_id: user.id).page(params[:page]).per(params[:per_page])
        render json: posts, status: :ok
      end

    end
  end
end