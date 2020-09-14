# frozen_string_literal: true

module Api
  module V1
    class PostsController < ::Api::ApiController
      before_action :find_post, except: :index
      def index
        posts = Post.by_title_or_description(params[:search])
                    .or(Post.by_user_full_name(params[:search]))
                    .reorder(params[:sorting])
        render json: posts, status: :ok
      end

      def show
        raise ::Errors::NotFound if @post.banned? && current_user.id != @post.user.id

        render json: @post, status: :ok
      end

      def create
        outcome = ::Posts::Create.run(post_params)
        validate_result outcome
      end

      def destroy
        validate_user User.find(@post.user_id)

        @post.destroy
        render json: { message: 'destroyed' }, status: :ok
      end

      def update
        validate_user User.find(@post.user_id)

        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      private

      def find_post
        @post = Post.find(params[:id])
      end

      def post_params
        {
          user: current_user,
          title: params['title'],
          description: params['description'],
          photo: params['photo']
        }
      end
    end
  end
end
