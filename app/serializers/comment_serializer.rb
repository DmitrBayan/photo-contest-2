# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :body

  belongs_to :user
end