# frozen_string_literal: true

module UserPhotoValidator
  extend ActiveSupport::Concern

  include PhotoValidator

  included do
    def min_width
      50
    end

    def min_height
      50
    end
  end
end
