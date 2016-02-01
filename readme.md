account = Account.first
client = Twitter::REST::Client.new do |let|
  let.consumer_key = Rails.application.secrets.twitter_consumer_public
  let.consumer_secret = Rails.application.secrets.twitter_consumer_private
  let.access_token = account.access_public
  let.access_token_secret = account.access_private
end
blocks = client.blocked_ids; nil
blocks.count
