# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox, :backburner, :que, :sucker_punch
Devise::Async.setup do |config|
  config.enabled = true
  config.backend = :resque
  config.queue   = :mailers
end