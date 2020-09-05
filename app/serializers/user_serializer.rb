# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :image_url

  has_many :posts

  def image_url
    object.image_url.show
  end
end