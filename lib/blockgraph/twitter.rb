module Blockgraph
  class Twitter

    attr_reader :client
    attr_reader :logger
    delegate :follower_ids, to: :client
    delegate :block, to: :client
    delegate :unblock, to: :client
    delegate :user, to: :client

    def initialize(access_public, access_private, logger)
      @client = ::Twitter::REST::Client.new do |let|
        let.consumer_key = Rails.application.secrets.twitter_consumer_public
        let.consumer_secret = Rails.application.secrets.twitter_consumer_private
        let.access_token = access_public
        let.access_token_secret = access_private
      end
      @logger = logger
      @success = -> (*arguments) { }
      @failure = -> (*arguments) { }
    end

    def failure(&block)
      if block_given?
        @failure = block
      else
        @failure
      end
    end

    def lazily
      yield
    rescue => exception
      logger.info(exception)
      failure.call(exception)
    end
  end
end
