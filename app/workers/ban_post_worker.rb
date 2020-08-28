# frozen_string_literal: true

class BanPostWorker
  include Sidekiq::Worker

  def perform(post_id)
    byebug
    post = Post.find_by(id: post_id)
    return if post.blank?

    post.destroy
  end
end
