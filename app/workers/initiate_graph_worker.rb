class InitiateGraphWorker
  include Sidekiq::Worker

  def perform(account_id, block_id, username)
    account = Account.find_by!(id: account_id)
    block = Block.find_by!(id: block_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private, logger)

    client.lazily(self.class, account_id, block_id, username) do
      user = client.user(username)

      profile = Profile.twitter.where(external_id: user.id).first_or_create!

      ConnectTrunkProfileWorker.perform_async(block.id, profile.id)
      BlockTwitterUserWorker.perform_async(account.id, profile.id)

      DigGraphWorker.perform_async(account.id, block.id, profile.id)
    end
  end
end
