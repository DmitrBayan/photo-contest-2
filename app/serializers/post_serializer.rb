# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :photo, :likes_count, :comments_count

  belongs_to :user

  has_many :comments

  def photo
    object.photo.show
  end
end
