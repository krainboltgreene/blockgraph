class BlockConnectionWorker
  include Sidekiq::Worker

  def perform(block_id, username, external_id)
    @block = Block.find_by(id: block_id)

    @profile = Profile.where(username: username, external_id: external_id, provider: "twitter").first_or_create
    @connection = Connection.create(block: @block, profile: @profile, trunk: @block.trunk)
  end
end
