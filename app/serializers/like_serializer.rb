# frozen_string_literal: true

class LikeSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  belongs_to :user
  belongs_to :post
end
