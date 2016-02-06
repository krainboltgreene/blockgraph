class UnblockTwitterUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :blocking

  def perform(account_id, profile_id)
    account = Account.find_by!(id: account_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private, logger)

    client.lazily(self.class, account_id, profile_id) do
      client.unblock(profile.external_id.to_i)
    end
  end
end
