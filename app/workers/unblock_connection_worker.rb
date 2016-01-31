class UnblockConnectionWorker
  include Sidekiq::Worker

  def perform(block_id, profile_id)
    @block = Block.find_by(id: block_id)
    logger.info("Found block #{block_id}")
    @profile = Profile.find_by(id: profile_id)
    logger.info("Found profile #{profile_id}")
    @client = client
    logger.info("Created client")

    lazily { @client.unblock(@profile.external_id.to_i) }
    logger.info("Unblocked #{@profile.username}")

    @profile.destroy
    logger.info("Destroyed #{@profile.id}")
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
