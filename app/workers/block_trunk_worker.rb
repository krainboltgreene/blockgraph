class BlockTrunkWorker
  include Sidekiq::Worker

  def perform(block_id, username)
    Rails.logger.info("Starting #{self.class}")
    @block = Block.find_by(id: block_id)
    Rails.logger.info("Found block #{block_id}")
    @client = client
    Rails.logger.info("Created client")

    lazily { @user = @client.user(username) }
    Rails.logger.info("Got user")
    lazily { @client.block(@user) }
    Rails.logger.info("Blocked user")
    lazily { @followers = @client.followers(@user) }
    Rails.logger.info("Got followers")
    lazily { @client.block(@followers.map(&:id)) }
    Rails.logger.info("Blocked followers")

    @profile = Profile.where(username: @user.screen_name, external_id: @user.id, provider: "twitter").first_or_create!
    @connection = Connection.create(block: @block, profile: @profile)

    @followers.each do |follower|
      BlockConnectionWorker.perform_async(@block.id, follower.screen_name, follower.id)
    end

    @block.leafs.where.not(external_id: followers.map(&:id)).pluck(:id).each do |leaf_id|
      UnblockConnectionWorker.perform_async(@block.id, leaf_id)
    end
  end

  def lazily
    yield
  rescue Twitter::Error::TooManyRequests => exception
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
