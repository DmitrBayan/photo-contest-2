# frozen_string_literal: true

module Posts
  class Create < ActiveInteraction::Base
    object :user
    string :title
    string :description
    file :photo, class: ::PhotoUploader

    def execute
      post = user.posts.build(title: title, description: description, photo: photo)
      post.save ? post : post.errors
    end
  end
end
