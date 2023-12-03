# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL', nil), network_timeout: 5 }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL', nil), network_timeout: 5 }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end
