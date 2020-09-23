# frozen_string_literal: true

module MetaData
  extend ActiveSupport::Concern

  included do
    def current_user_meta
      if current_user.blank?
        { current_user: nil }
      else
        {
          current_user: {
            id: current_user.id,
            first_name: current_user.first_name,
            last_name: current_user.last_name,
            avatar: current_user.avatar.thumb
          }
        }
      end
    end

    def liked?(post = nil, meta = {})
      return if post.blank?
      return if current_user.blank?

      {
        liked: @post.likes.find_by(user_id: current_user.id).present?
      }.merge(meta)
    end

    def pagination_meta(object, meta = {})
      {
        current_page: object.current_page,
        next_page: object.next_page,
        previous_page: object.previous_page,
        total_pages: object.total_pages,
        per_page: object.per_page
      }.merge(meta)
    end
  end
end
