# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar

  has_many :posts

  def avatar
    object.avatar.show
  end
end
