class FetchTwitterUserWorker
  include Sidekiq::Worker

  def perform(profile_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(Rails.application.secrets.twitter_access_public, Rails.application.secrets.twitter_access_private)

    user = client.lazily { client.user(profile.external_id.to_i) }

    profile.update(username: user.screen_name)
  end
end
