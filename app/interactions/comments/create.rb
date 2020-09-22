# frozen_string_literal: true

module Comments
  class Create < ActiveInteraction::Base
    object :user
    integer :post_id
    string :body
    integer :parent_comment_id, default: nil

    def execute
      post = Post.find_by(id: post_id)
      raise ::Errors::NotFound if post.blank?

      post.comments.create(body: body, user_id: user.id,
                           parent_comment_id: parent_comment_id)
    end
  end
end
