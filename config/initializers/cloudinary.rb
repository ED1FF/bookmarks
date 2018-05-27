Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUD_NAME']
  config.api_key = ENV['API_KEY_CLOUD']
  config.api_secret = ENV['API_SECRET_CLOUD']
  config.secure = true
  config.cdn_subdomain = true
end
