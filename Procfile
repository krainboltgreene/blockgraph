web: bin/rails server -p $PORT
worker: bundle exec sidekiq -q blocking,3 -q default,2 -q connecting,2 -q fetching -c 10
