# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @posts = Post.paginate(page: params[:page], per_page: 9).approved
  end
end
