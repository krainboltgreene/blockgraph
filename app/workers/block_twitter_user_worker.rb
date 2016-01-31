class BlockTwitterUserWorker
  include Sidekiq::Worker

  def perform(account_id, profile_id)
    account = Account.find_by!(id: account_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private)

    client.lazily { client.block(profile.external_id.to_i) }
  end
end
