class UnconnectProfileWorker
  include Sidekiq::Worker

  sidekiq_options queue: :connecting

  def perform(block_id, profile_id)
    block = Block.find_by!(id: block_id)

    block.connections.leafs.where(profile_id: profile_id).each(&:destroy)
  end
end
