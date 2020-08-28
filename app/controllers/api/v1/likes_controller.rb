module Api
  module V1
    class LikesController < ::Api::ApiController
      layout false
      before_action :verify_authenticity_token, :find_post

      def create
        if @post.likes.find_by(user_id: @api_user).present?
          ::Likes::Destroy.run(post: @post, user: @api_user)
          render json: {message: 'liked'}, status: :ok
        else
          ::Likes::Create.run(post: @post, user: @api_user)
          render json: {message: 'unliked'}, status: :ok
        end
      end

      private

      def find_post
        @post = Post.find(params[:post_id])
      end
    end
  end
end
