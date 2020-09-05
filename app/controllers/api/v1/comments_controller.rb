module Api
  module V1
    class CommentsController < ::Api::ApiController

      def create
        @post = Post.find(params[:post_id])
        outcome = Comments::Create.run(comment_params)
        validate_result outcome
      end

      def destroy
        comment = Comment.find(params[:id])
        validate_user User.find(comment.user_id)

        comment.destroy
        render json: {message: 'destroyed'}, status: :ok
      end

      def show
        comment = Comment.find(params[:id])
        render json: comment, status: :ok
      end

      private

      def comment_params
        {
            post: @post, user: @api_user,
            body: params['body'],
            parent_comment_id: params[:parent_comment_id]
        }
      end
    end
  end
end
