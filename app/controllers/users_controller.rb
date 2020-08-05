# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = if @user.eql?(current_user)
               @user.posts.reorder(params[:sorting])
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
    params.require(:user).permit(:first_name, :last_name)
  end
end
