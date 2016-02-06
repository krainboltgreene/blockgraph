module Blockgraph
  class Twitter

    attr_reader :client
    delegate :follower_ids, to: :client
    delegate :block, to: :client
    delegate :user, to: :client

    def initialize(access_public, access_private, logger)
      @client = ::Twitter::REST::Client.new do |let|
        let.consumer_key = Rails.application.secrets.twitter_consumer_public
        let.consumer_secret = Rails.application.secrets.twitter_consumer_private
        let.access_token = access_public
        let.access_token_secret = access_private
      end
      @logger = logger
    end

    def lazily(worker, *arguments)
      yield
    rescue ::Twitter::Error::TooManyRequests => exception
      @logger.info("Hit rate limit: #{arguments.inspect}")
      worker.perform_in(exception.rate_limit.reset_in, *arguments)

    rescue ::Twitter::Error::NotFound => exception
      @logger.info("Failed to find: #{arguments.inspect}")

    rescue ::Twitter::Error::Forbidden => exception
      @logger.info("Failed to find: #{arguments.inspect}")

    end
  end
end
