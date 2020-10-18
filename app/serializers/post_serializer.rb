# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :photo, :likes_count, :comments_count, :liked

  belongs_to :user

  has_many :comments

  def photo
    object.photo.show
  end

  def liked
    object.likes.map(&:user_id).include?(current_user.id)
  end
end
