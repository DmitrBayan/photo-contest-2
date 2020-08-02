# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :must_logged, only: %i[create destroy new]

  def new; end

  def index
    @posts = Post.approved
                 .where(["lower(title) || ' ' || lower(description) LIKE ?",
                         "%#{params[:search].downcase if params[:search].present?}%"])
                 .reorder(params[:sorting])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def create
    outcome = ::Posts::Create.run(post_params)
    if outcome.valid?
      @post = outcome.result
      flash[:success] = 'Post submitted for moderation!'
      redirect_to current_user
    else
      flash[:warning] = outcome.errors.full_messages
      render 'new'
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
    redirect_to root_path
  end

  private

  def post_params
    {
      user: current_user,
      title: params[:post]['title'],
      description: params[:post]['description'],
      photo: params[:post]['photo']
    }
  end
end
