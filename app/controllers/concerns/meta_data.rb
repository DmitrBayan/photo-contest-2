# frozen_string_literal: true

module MetaData
  extend ActiveSupport::Concern

  included do
    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        previous_page: collection.previous_page,
        total_pages: collection.total_pages,
        per_page: collection.per_page,
        total_entries: collection.total_entries
      }
    end
  end
end
