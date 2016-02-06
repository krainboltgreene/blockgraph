class ConnectLeafProfileWorker
  include Sidekiq::Worker

  sidekiq_options queue: :connecting

  def perform(block_id, profile_id, trunk_id)
    block = Block.find_by!(id: block_id)
    profile = Profile.find_by!(id: profile_id)
    raise ActiveRecord::RecordNotFound, "wasn't given trunk" unless trunk_id

    Connection.where(block: block, profile: profile, trunk_id: trunk_id).first_or_create!
  end
end
