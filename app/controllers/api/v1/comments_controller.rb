# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ::Api::ApiController
      before_action :find_comment, except: :create

      def create
        outcome = Comments::Create.run(comment_params)
        validate_result outcome
      end

      def destroy
        validate_user User.find(@comment.user_id)

        @comment.destroy
        render json: { message: 'destroyed' }, status: :ok
      end

      def show
        render json: @comment, status: :ok
      end

      private

      def find_comment
        @comment = Comment.find_by(id: params[:id])
        raise ::Errors::NotFound if @comment.blank?
      end

      def comment_params
        {
          post_id: params[:post_id], user: current_user,
          body: params['body'],
          parent_comment_id: params[:parent_comment_id]
        }
      end
    end
  end
end
