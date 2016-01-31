class BlockConnectionWorker
  include Sidekiq::Worker

  def perform(block_id, username, external_id)
    @block = Block.find_by(id: block_id)
    logger.info("Found block #{block_id}")
    @client = client
    logger.info("Authenticated client")

    lazily { @client.block(external_id) }
    logger.info("Blocked #{username}")

    @profile = Profile.where(username: username, external_id: external_id, provider: "twitter").first_or_create
    logger.info("Creating/finding profile")

    @connection = Connection.where(block: @block, profile: @profile, trunk: @block.trunk).first_or_create
    logger.info("Creating/finding leaf connection")
  end

  def lazily
    yield
  rescue Twitter::Error::TooManyRequests => exception
    logger.info("Had to wait for #{exception.rate_limit.reset_in + 1}")
    sleep(exception.rate_limit.reset_in + 1) and retry
  end

  def client
    Twitter::REST::Client.new do |let|
      let.consumer_key = Rails.application.secrets.twitter_consumer_public
      let.consumer_secret = Rails.application.secrets.twitter_consumer_private
      let.access_token = @block.account.access_public
      let.access_token_secret = @block.account.access_private
    end
  end
end
