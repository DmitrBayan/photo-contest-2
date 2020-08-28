module Api
  module V1
    class CommentsController < ::Api::ApiController
      layout false
      before_action :verify_authenticity_token

      def create
        @post = Post.find(params[:post_id])
        outcome = Comments::Create.run(comment_params)
        validate outcome
      end

      def destroy
        comment = Comment.find(params[:id])
        raise ::Errors::Unright unless @api_user.id == comment.user_id

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
