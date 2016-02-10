class BlockTwitterUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :blocking

  def perform(account_id, profile_id)
    account = Account.find_by!(id: account_id)
    profile = Profile.find_by!(id: profile_id)
    client = Blockgraph::Twitter.new(account.access_public, account.access_private, logger)

    client.failure do |exception|
      case exception
      when ::Twitter::Error::TooManyRequests
        self.class.perform_in(exception.rate_limit.reset_in + 1.second, account_id, profile_id)
      when ::Twitter::Error::NotFound, ::Twitter::Error::Forbidden
        profile.destroy
      else raise exception
      end
    end

    client.lazily do
      user = client.block(profile.external_id.to_i)

      profile.update(username: user.screen_name)
    end
  end
end
