# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :logged?, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def new
    @comment = ::Comments::Create.new
  end

  def create
    @post = Post.find(params[:post_id])
    outcome = Comments::Create.run(comment_params)
    return unless outcome.valid?

    flash[:success] = 'Commented.'
    redirect_to @post
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment deleted.'
    redirect_to request.referer || current_user
  end

  private

  def correct_user
    @comment = current_user.comments.find_by(params[:comment_id])
    return if @comment.present?

    redirect_to request.referer || root_path
    flash[:warning] = 'It is not your comment!'
  end

  def comment_params
    { post: @post, user: current_user,
      body: params[:comment]['body'],
      parent_comment_id: params[:parent_comment_id] }
  end
end
