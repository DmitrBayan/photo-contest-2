# frozen_string_literal: true

class PhotoResolutionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    min_width = options[:min_width]
    min_height = options[:min_height]
    return if value.blank?
    return unless value.width < min_width || value.height < min_height

    record.errors.add(attribute, :invalid_resolution, message: "should be #{min_width}x#{min_height}px minimum.")
  end
end
