# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :must_logged, only: %i[create destroy new]
  before_action :check_user_ban, only: %i[create new]
  before_action :get_vk_collection, only: %i[create new]

  def new
    @post ||= ::Posts::Create.new
  end

  def index
    @posts = Post.by_title_or_description(params[:search])
                 .or(Post.by_user_full_name(params[:search]))
                 .reorder(params[:sorting])
                 .paginate(page: params[:page], per_page: 9)
    respond_to do |format|
      format.html
      format.js
    end
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
      redirect_to @post
    else
      @post = outcome
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

  def share
    @post = Post.find(params[:post_id])
    share = PostsHelper::Share.new
    redirect_to share.sharing(@post, params[:url])
  end

  private

  def get_vk_collection
    return unless current_user.provider == 'vkontakte'

    vk = VkontakteApi::Client.new(current_user.access_token)
    @collection = vk.photos.get_all(vk_api_params)
  end

  def post_params
    {
      user: current_user,
      title: params[:post]['title'],
      description: params[:post]['description'],
      photo: params[:post]['photo'],
      remote_photo: params[:post]['remote_photo']
    }
  end

  def vk_api_params
    {
        count: 8,
        owner_id: current_user.uid,
        v: 5.21
    }
  end
end
