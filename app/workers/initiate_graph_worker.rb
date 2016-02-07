class InitiateGraphWorker
  include Sidekiq::Worker

  sidekiq_options throttle: { key: "GET users/show", threshold: 180, period: 15.minutes }

  def perform(account_id, block_id, username)
    account = Account.find_by!(id: account_id)
    block = Block.find_by!(id: block_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private, logger)

    client.failure do |exception|
      case exception
      when ::Twitter::Error::TooManyRequests
        self.class.perform_in(exception.rate_limit.reset_in + 1.second, account_id, block_id, username)
      else raise exception
      end
    end

    client.lazily do
      user = client.user(username)

      profile = Profile.twitter.where(external_id: user.id).first_or_create!
      ConnectTrunkProfileWorker.perform_async(block.id, profile.id)
      BlockTwitterUserWorker.perform_async(account.id, profile.id)

      DigGraphWorker.perform_async(account.id, block.id, profile.id)
    end
  end
end
