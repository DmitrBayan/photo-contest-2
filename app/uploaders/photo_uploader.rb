# frozen_string_literal: true

class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process resize_to_limit: [1000, 1000]

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "public/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  version :admin do
    process resize_to_limit: [100, 100]
  end

  version :show do
    process resize_to_fill: [300, 300]
  end

  version :thumb do
    process resize_to_fill: [40, 40]
  end

  version :user_show do
    process resize_to_fill: [150, 150]
  end
end
