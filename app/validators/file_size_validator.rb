# frozen_string_literal: true

class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    size = options[:size]
    return if value.blank?
    return if value.file.size.to_f / (1024 * 1024) < size.to_f

    record.errors.add(attribute, :invalid_size, message: "should be less than #{size} MB.")
  end
end
