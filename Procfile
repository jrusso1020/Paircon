redis: redis-server
postgres: postgres -D /usr/local/var/postgres
paircon: sh -c "cd Web && rails s"
similiarity: sh -c "cd SimilarityAlgo && python app.py"
worker: sh -c "cd Web && bundle exec sidekiq -q default -q mailers"