# frozen_string_literal: true

module Posts
  class Create < ActiveInteraction::Base
    object :user
    string :title
    string :description
    file :photo, class: ::PhotoUploader

    def execute
      user.posts.build(title: title, description: description, photo: photo)
    end
  end
end
