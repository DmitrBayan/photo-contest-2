# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = if @user.eql?(current_user)
               params[:filter].present? ? @user.posts.by_state(params[:filter]) : @user.posts
             else
               @user.posts.approved
             end
  end

  def index
    @users = User.by_full_name(params[:search])
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
    params.require(:user).permit(:first_name, :last_name, :image_url)
  end

  def set_auth_token
    current_user.set_authenticity_token
    redirect_to edit_user_path(current_user)
  end
end
