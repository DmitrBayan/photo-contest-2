# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @posts = Post.includes(:comments).paginate(page: params[:page]).approved
  end
end
