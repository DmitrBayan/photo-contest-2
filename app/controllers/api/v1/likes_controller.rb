module Api
  module V1
    class LikesController < ::Api::ApiController
      before_action :find_post

      def create
        if already_liked?
          render json: { message: "you're already liked it" }, status: :ok
        else
          ::Likes::Create.run(post: @post, user: @api_user)
          render json: { message: 'liked' }, status: :ok
        end
      end

      def destroy
        if already_liked?
          ::Likes::Destroy.run(post: @post, user: @api_user)
          render json: { message: 'unliked' }, status: :ok
        else
          render json: { message: "you're already unliked it" }, status: :ok
        end
      end

      private

      def already_liked?
        @post.likes.find_by(user_id: @api_user).present?
      end

      def find_post
        @post = Post.find(params[:post_id])
      end
    end
  end
end
