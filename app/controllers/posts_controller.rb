# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :logged?, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def index
    @posts = Post.approved
              .where(['title LIKE ?', "%#{params[:search]}%"])
              .reorder(params[:sorting])
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post submitted for moderation!'
      redirect_to current_user
    else
      redirect_to request.referer || root_path
      flash[:warning] = @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_to request.referer || current_user
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :description)
  end

  def correct_user
    @post = current_user.posts.find(params[:id])
    redirect_to root_path if @post.blank?
  end
end
