# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @post = current_user.posts.build if logged?
    @posts = Post.includes(:comments).paginate(page: params[:page]).approved
  end
end
