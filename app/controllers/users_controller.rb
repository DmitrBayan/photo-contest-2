# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page]).approved
  end

  def index
    @users = User.paginate(page: params[:page])
              .where(['first_name LIKE ?', "%#{params[:search]}%"])
              .reorder(params[:sorting])
  end
end
