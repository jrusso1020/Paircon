redis_host = ENV['REDIS_HOST'] || 'localhost'
redis_port = ENV['REDIS_PORT'] || '6379'
Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 15
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}/12" }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}/12" }
end