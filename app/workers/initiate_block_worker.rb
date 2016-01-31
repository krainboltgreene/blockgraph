class InitiateBlockWorker
  include Sidekiq::Worker

  def perform(account_id, block_id, external_id, trunk_id)
    profile = Profile.twitter.where(external_id: external_id).first_or_create!

    ConnectProfileWorker.perform_async(block_id, profile.id, trunk_id)
    BlockTwitterUserWorker.perform_async(account_id, external_id)
  end
end
