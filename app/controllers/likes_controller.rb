# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_post, :must_logged

  def create
    if @post.likes.find_by(user_id: current_user).present?
      ::Likes::Destroy.run(post: @post, user: current_user)
      flash[:success] = 'Unliked!'
    else
      ::Likes::Create.run(post: @post, user: current_user)
      flash[:success] = 'Liked!'
    end
    redirect_to request.referer || root_path
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end
