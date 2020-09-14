# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :body, :id

  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment
end
