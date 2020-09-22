# frozen_string_literal: true

module PaginatableData
  extend ActiveSupport::Concern

  included do
    def pagination_meta(object)
      {
        current_page: object.current_page,
        next_page: object.next_page,
        previous_page: object.previous_page,
        total_pages: object.total_pages,
        per_page: object.per_page
      }
    end
  end
end
