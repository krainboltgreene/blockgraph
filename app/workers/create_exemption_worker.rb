class CreateExemptionWorker
  include Sidekiq::Worker

  def perform(account_id, profile_id)
    account = Account.find_by!(id: account_id)
    profile = Profile.find_by!(id: profile_id)

    account.exemptions.create!(external_id: profile.external_id)
    UnblockTwitterUserWorker.perform_async(account.id, profile.id)
  end
end
