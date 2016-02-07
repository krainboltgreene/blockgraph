class DigGraphWorker
  include Sidekiq::Worker

  sidekiq_options throttle: { key: "GET followers/ids", threshold: 15, period: 15.minutes }

  def perform(account_id, block_id, profile_id)
    account = Account.find_by!(id: account_id)
    block = Block.find_by!(id: block_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private, logger)

    client.failure do |exception|
      case exception
      when ::Twitter::Error::TooManyRequests
        self.class.perform_in(exception.rate_limit.reset_in + 1.second, account_id, block_id, profile_id)
      else raise exception
      end
    end

    client.lazily do
      followers = client.follower_ids(profile.external_id.to_i).to_a

      followers.each do |external_id|
        InitiateBlockWorker.perform_async(account.id, block.id, external_id, profile.id)
      end

      block.connections.leafs.missing(followers.map(&:to_s)).pluck(:profile_id).each do |profile_id|
        InitiateUnblockWorker.perform_async(account.id, block.id, profile_id, profile.id)
      end

      DigGraphWorker.perform_in(1.day, account_id, block_id, profile_id)
    end
  end
end
