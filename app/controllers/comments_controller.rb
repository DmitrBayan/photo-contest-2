# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :logged?, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  before_action :find_commentable, only: :create

  after_action :increment_comments_count, only: :create
  after_action :decrement_comments_count, only: :destroy

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'Commented!'
      redirect_to request.referer
    else
      redirect_to request.referer || root_path
      flash[:warning] = @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referer || current_user
  end

  private

  def correct_user
    @comment = current_user.comments.find_by(params[:id])
    return if @comment.present?

    redirect_to request.referer || root_path
    flash[:warning] = 'It is not your comment'
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = Comment.find(params[:format]) if params[:format]
    @commentable = Post.find(params[:post_id]) if params[:post_id]
  end

  def increment_comments_count
    if @commentable.class == Post
      @commentable.increment!(:comments_count)
      return
    end
    until @commentable.commentable_type == 'Post'
      @commentable = Comment.find(@commentable.commentable_id)
    end
    Post.find(@commentable.commentable_id).increment!(:comments_count)
  end

  def decrement_comments_count
    until @comment.commentable_type == 'Post'
      @comment = Comment.find(@comment.commentable_id)
    end
    Post.find(@comment.commentable_id).decrement!(:comments_count)
  end
end
