# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :must_logged, only: %i[create destroy new]

  def new; end

  def index
    @posts = Post.approved
                 .where(['title LIKE ?', "%#{params[:search]}%"])
                 .reorder(params[:sorting])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post submitted for moderation!'
      redirect_to current_user
    else
      flash[:warning] = @post.errors.full_messages.to_sentence
      redirect_to request.referer || root_path
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.present?
      @post.destroy
      flash[:success] = 'Post deleted'
    else
      flash[:warning] = "It's not your post!"
    end
    redirect_to request.referer || root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :description)
  end
end
