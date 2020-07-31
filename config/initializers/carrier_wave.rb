# frozen_string_literal: true

if Rails.env.production?
 CarrierWave.configure do |config|
   config.fog_credentials = {
     provider: 'AWS',
     aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
     aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
     aws_bucket: Rails.application.credentials.dig(:aws, :bucket)
   }
   config.fog_directory = Rails.application.credentials.dig(:aws, :bucket)
 end
end
