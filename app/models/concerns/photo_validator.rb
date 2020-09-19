# frozen_string_literal: true

module PhotoValidator
  extend ActiveSupport::Concern

  included do
    def photo_size
      return unless @file.file.size.to_f / (1024 * 1024) > 5.0

      errors.add :file, 'You cannot upload a file greater than 5 MB'
    end

    def minimum_photo_size
      if @file.width < 300 && file.height < 300
        errors.add :file, 'should be 300x300px minimum!'
      end
    end

    before_validation do
      self.class == User ? @file = image_url : @file = photo
    end

    validate :photo_size, :minimum_photo_size
  end
end