# frozen_string_literal: true

module Likes
  class Destroy < ActiveInteraction::Base
    object :user
    object :post

    def execute
      post.likes.find_by(user_id: user.id).destroy
    end
  end
end
