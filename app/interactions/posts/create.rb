# frozen_string_literal: true

module Posts
  class Create < ActiveInteraction::Base
    object :user
    string :title
    string :description
    file :photo, class: ::PhotoUploader

    validates :title, presence: true

    def to_model
      Post.new
    end

    def execute
      post = user.posts.build(title: title, description: description, photo: photo)
      errors.merge!(post.errors) unless post.save
    end
  end
end
