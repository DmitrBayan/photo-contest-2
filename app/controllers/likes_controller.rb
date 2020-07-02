# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like

  helper_method :already_liked?

  def create
    must_logged && return unless logged?
    if already_liked?
      @like.destroy
      flash[:success] = 'Unliked!'
    else
      @post.likes.create(user_id: current_user.id)
      flash[:success] = 'Liked!'
    end
    redirect_to request.referer || root_path
  end

  def destroy; end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find_by(params[:id])
  end
end
