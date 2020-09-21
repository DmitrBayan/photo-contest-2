# frozen_string_literal: true

module PostPhotoValidator
  extend ActiveSupport::Concern

  include PhotoValidator

  included do
    def min_width
      300
    end

    def min_height
      300
    end
  end
end