# frozen_string_literal: true

module PhotoValidator
  extend ActiveSupport::Concern

  included do
    attr_reader :file

    MIN_WIDTH = 100
    MIN_HEIGHT = 100

    def min_width
      MIN_WIDTH
    end

    def min_height
      MIN_HEIGHT
    end

    def photo_size
      errors.add :photo, 'should be less than 5 MB.' if file.file.size.to_f / (1024 * 1024) > 5.0
    end

    def minimum_photo_size
      return unless file.width < min_width || file.height < min_height

      errors.add :photo, "should be #{min_width}x#{min_height}px minimum."
    end

    def file_present?
      return true if file.present?

      errors.add :photo, 'must be present.'
    end

    validate :file_present?
    validate :photo_size, :minimum_photo_size, if: :file_present?
  end
end
