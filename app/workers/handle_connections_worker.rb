class HandleConnectionsWorker
  include Sidekiq::Worker

  def perform(block_id, profile_id)
    @block = Block.find_by(id: block_id)
    logger.info("Found block #{block_id}")
    @profile = Profile.find_by(id: profile_id)
    logger.info("Found profile #{profile_id}")
    @client = client
    logger.info("Created client")

    lazily { @user = @client.user(@profile.external_id) }
    logger.info("Got user")
    lazily { @followers = @client.followers(@user) }
    logger.info("Got followers")

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
