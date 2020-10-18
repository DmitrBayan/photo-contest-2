# frozen_string_literal: true

module Posts
  class Create < ActiveInteraction::Base
    object :user
    string :title
    string :description
    file :photo, class: ::PhotoUploader, default: nil
    string :remote_photo, default: nil
    string :ip

    validates :title, presence: true

    def to_model
      Post.new
    end

    def execute
      coordinates = Geocoder.search(ip).first.coordinates unless ip == '127.0.0.1'
      post = user.posts.build(title: title,
                              description: description,
                              photo: photo, remote_photo_url: remote_photo,
                              coordinates: coordinates)
      errors.merge!(post.errors) unless post.save
      post
    end
  end
end
