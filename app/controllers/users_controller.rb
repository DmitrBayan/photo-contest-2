# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(params[:filter])
  end

  def index
    @users = User.where(["lower(first_name) || ' ' || lower(last_name) LIKE ?",
                         "%#{params[:search].downcase if params[:search].present?}%"])
                 .paginate(page: params[:page])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to current_user || root_path
    else
      render 'edit'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
