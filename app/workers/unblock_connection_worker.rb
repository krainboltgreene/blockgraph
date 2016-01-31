class UnblockConnectionWorker
  include Sidekiq::Worker

  def perform(block_id, profile_id)
    @block = Block.find_by(id: id)
    @profile = Profile.find_by(id: profile_id)
    @client = client

    lazily { @client.unblock(@profile.external_id) }

    @profile.destroy
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
