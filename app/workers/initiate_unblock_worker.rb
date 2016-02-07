class InitiateUnblockWorker
  include Sidekiq::Worker

  def perform(account_id, block_id, profile_id, trunk_id)
    UnconnectLeafProfileWorker.perform_async(block_id, profile_id, trunk_id)
    UnblockTwitterUserWorker.perform_async(account_id, profile_id)
  end
end
