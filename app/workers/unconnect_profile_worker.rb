class UnconnectProfileWorker
  include Sidekiq::Worker

  sidekiq_options queue: :connecting

  def perform(block_id, profile_id)
    block = Block.find_by!(id: block_id)
    profile = Profile.find_by!(id: profile_id)

    block.leafs.where(profile: profile).each(&:destroy)
  end
end
