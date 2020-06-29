# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :logged?, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  before_action :find_commentable, only: :create

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'Commented!'
      redirect_to request.referrer
    else
      redirect_to request.referrer || root_path
      flash[:warning] = @comment.errors.full_messages.to_sentence
    end
  end

  after_action on: [:create] do
    begin
      Post.find(params[:post_id]).increment!(:comments_count)
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_to request.referrer || current_user
  end

  after_action on: [:destroy] do
    begin
      @commentable.decrement!(:comments_count)
    end
  end

  private

  def correct_user
    @comment = current_user.comments.find_by(params[:id])
    if @comment.blank?
      redirect_to request.referrer || root_path
      flash[:warning] = 'It is not your comment'
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = Comment.find(params[:format]) if params[:format]
    @commentable = Post.find(params[:post_id]) if params[:post_id]
  end

  def commentable_post
    

end
