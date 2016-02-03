class DigGraphWorker
  include Sidekiq::Worker

  def perform(account_id, block_id, profile_id)
    account = Account.find_by!(id: account_id)
    block = Block.find_by!(id: block_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private)

    client.lazily(self.class, account_id, block_id, profile_id) do
      followers = client.follower_ids(profile.external_id.to_i).to_a

      followers.each do |external_id|
        InitiateBlockWorker.perform_async(account.id, block.id, external_id, profile.id)
      end

      block.connections.leafs.missing(followers.map(&:to_s)).pluck(:id).each do |profile_id|
        UnconnectProfileWorker.perform_async(block.id, profile_id)
        UnblockTwitterUserWorker.perform_async(block.id, profile_id)
      end

      DigGraphWorker.perform_in(1.day, account_id, block_id, profile_id)
    end
  end
end
