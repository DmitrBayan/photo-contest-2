# frozen_string_literal: true

module Api
  module V1
    class UsersController < ::Api::ApiController
      before_action :find_user, except: %i[index current]
      def index
        per_page = [params[:per_page].to_i, 1].max
        page = [params[:page].to_i, 1].max
        users = User.by_full_name(params[:search])
                    .paginate(page: page, per_page: per_page)
        render json: users,
               status: :ok,
               meta: pagination_meta(users)
      end

      def show
        render json: @user,
               status: :ok
      end

      def destroy
        validate_user @user

        @user.destroy
        render json: { message: 'removed' }, status: :ok
      end

      def update
        validate_user @user

        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def current
        render json: current_user
      end

      private

      def find_user
        @user = User.find_by(id: params[:id])
        raise ::Errors::NotFound if @user.blank?
      end

      def user_params
        params.permit(:first_name, :last_name, :avatar, :email)
      end
    end
  end
end
