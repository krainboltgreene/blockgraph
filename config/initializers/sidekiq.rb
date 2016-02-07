Sidekiq.configure_client do |let|
  let.redis = { size: 4 }
end

Sidekiq.configure_server do |let|
  let.redis = { size: 25 }
  let.server_middleware do |chain|
    chain.add Sidekiq::Throttler, storage: :redis
  end
end
