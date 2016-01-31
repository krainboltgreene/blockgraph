class BlockTrunkWorker
  include Sidekiq::Worker

  def perform(block_id, username)
    @block = Block.find_by(id: block_id)
    logger.info("Found block #{block_id}")
    @client = client
    logger.info("Authenticated client")

    lazily { @user = @client.user(username) }
    logger.info("Got user")
    lazily { @client.block(@user) }
    logger.info("Blocked #{username}")

    @profile = Profile.where(username: @user.screen_name, external_id: @user.id, provider: "twitter").first_or_create!
    logger.info("Creating/finding profile")

    @connection = Connection.where(block: @block, profile: @profile).first_or_create
    logger.info("Creating/finding trunk connection")

    HandleConnectionsWorker.perform_async(@block.id, @profile.id)
  end

  def lazily
    yield
  rescue Twitter::Error::TooManyRequests => exception
    logger.info("Had to wait for #{exception.rate_limit.reset_in + 1}")
    sleep(exception.rate_limit.reset_in + 1)
    raise exception
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
