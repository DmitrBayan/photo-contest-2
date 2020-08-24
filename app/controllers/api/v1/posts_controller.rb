module Api
  module V1
    class PostsController < ::ApiController
      layout false
      before_action :verify_authenticate_token

      def index
        @posts = Post.by_title_or_description(params[:search])
                     .or(Post.by_user_full_name(params[:search]))
                     .reorder(params[:sorting])
        render json: posts, status: :ok
      end

      def show
        @post = Post.find(params[:id])
        @comments = @post.comments
        render json: post, status: :ok
      end

      def create
        outcome = ::Posts::Create.run(post_params)
        validate outcome
      end

      def destroy
        @post = current_user.posts.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == @post.user_id

        @post.destroy
        render json: { message: 'destroyed' }, status: :ok
      end

      private

      def post_params
        {
            user: @api_user,
            title: params[:post]['title'],
            description: params[:post]['description'],
            photo: params[:post]['photo']
        }
      end
    end
  end
end