class UnconnectLeafProfileWorker
  include Sidekiq::Worker

  sidekiq_options queue: :connecting

  def perform(block_id, profile_id, trunk_id)
    block = Block.find_by!(id: block_id)

    block.connections.leafs.where(profile_id: profile_id, trunk_id: trunk_id).delete_all
  end
end
