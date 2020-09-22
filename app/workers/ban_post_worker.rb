# frozen_string_literal: true

class BanPostWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post.present? || post.banned?

    post.destroy
  end
end
