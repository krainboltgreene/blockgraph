class FetchTwitterUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fetching

  def perform(profile_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(Rails.application.secrets.twitter_access_public, Rails.application.secrets.twitter_access_private, logger)

    client.failure do |exception|
      case exception
      when ::Twitter::Error::TooManyRequests
        self.class.perform_in(exception.rate_limit.reset_in + 1.second, profile_id)
      when ::Twitter::Error::NotFound, ::Twitter::Error::Forbidden
        profile.destroy
      end
    end

    client.lazily do
      profile.update(username: client.user(profile.external_id.to_i).screen_name)
    end
  end
end
