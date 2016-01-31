module Blockgraph
  class Twitter

    attr_reader :client
    delegate :follower_ids, to: :client
    delegate :block, to: :client
    delegate :user, to: :client

    def initialize(access_public, access_private)
      @client = ::Twitter::REST::Client.new do |let|
        let.consumer_key = Rails.application.secrets.twitter_consumer_public
        let.consumer_secret = Rails.application.secrets.twitter_consumer_private
        let.access_token = access_public
        let.access_token_secret = access_private
      end
    end

    def lazily
      yield
    end
  end
end
