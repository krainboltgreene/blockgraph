class ConnectTrunkProfileWorker
  include Sidekiq::Worker

  def perform(block_id, profile_id)
    block = Block.find_by!(id: block_id)
    profile = Profile.find_by!(id: profile_id)

    Connection.create!(block: block, profile: profile)
  end
end
