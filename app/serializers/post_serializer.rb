# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :title, :description, :photo

  belongs_to :user

  has_many :likes
  has_many :comments

  def photo
    object.photo.show
  end
end