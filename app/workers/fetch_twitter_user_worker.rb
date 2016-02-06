class FetchTwitterUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fetching

  def perform(profile_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(Rails.application.secrets.twitter_access_public, Rails.application.secrets.twitter_access_private, logger)

    client.lazily(self.class, profile_id) do
      user = client.user(profile.external_id.to_i)

      profile.update(username: user.screen_name)
    end
  end
end
