Sidekiq.configure_server do |config|
  Sidekiq::Extensions.enable_delay!
  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://localhost:6379/" }
  schedule_file = 'config/schedule.yml'
  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  Sidekiq::Extensions.enable_delay!
  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://localhost:6379/" }
end
