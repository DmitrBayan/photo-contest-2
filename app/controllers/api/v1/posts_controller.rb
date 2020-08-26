module Api
  module V1
    class PostsController < ::Api::ApiController
      layout false
      before_action :verify_authenticity_token

      def index
        posts = Post.by_title_or_description(params[:search])
                     .or(Post.by_user_full_name(params[:search]))
                     .reorder(params[:sorting])
        render json: posts, status: :ok
      end

      def show
        post = Post.find(params[:id])
        comments = post.comments
        user = User.find(post.user_id)
        render json: [user, post, comments], status: :ok
      end

      def create
        outcome = ::Posts::Create.run(post_params)
        validate outcome
      end

      def destroy
        post = Post.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == post.user_id

        post.destroy
        render json: { message: 'destroyed' }, status: :ok
      end

      def update
        post = Post.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == post.user_id

        if post.update(post_params)
          render json: post, status: :ok
        else
          render json: {errors: post.errors}, status: :unprocessable_entity
        end
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