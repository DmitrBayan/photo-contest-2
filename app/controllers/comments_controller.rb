# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :logged?, :check_user_ban, only: %i[create destroy]

  def new; end

  def create
    @post = Post.find(params[:post_id])
    outcome = Comments::Create.run(comment_params)
    if outcome.valid?
      flash[:success] = 'Commented.'
    else
      flash[:warning] = outcome.errors.full_messages.to_s
    end
    redirect_to @post
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.present? && @comment.user_id.eql?(current_user.id)
      @comment.destroy
      flash[:success] = 'Comment deleted.'
    else
      flash[:warning] = "It's not your comment!"
    end
    redirect_to request.referer
  end

  private

  def comment_params
    {
      post: @post, user: current_user,
      body: params[:comment]['body'],
      parent_comment_id: params[:parent_comment_id]
    }
  end
end
