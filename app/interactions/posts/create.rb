# frozen_string_literal: true

module Posts
  class Create < ActiveInteraction::Base
    object :user
    string :title
    string :description
    file :photo, class: ::PhotoUploader, default: nil
    string :remote_photo, default: nil
    string :ip_address

    validates :title, presence: true

    def execute
      post = user.posts.build(title: title,
                              description: description,
                              photo: photo, remote_photo_url: remote_photo,
                              ip_address: ip_address)
      errors.merge!(post.errors) unless post.save
      post
    end
  end
end
