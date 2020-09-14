# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_post, :must_logged, :check_user_ban

  def create
    if @post.likes.find_by(user_id: current_user).present?
      ::Likes::Destroy.run(post: @post, user: current_user)
    else
      ::Likes::Create.run(post: @post, user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end
