redis: redis-server
paircon: sh -c "cd Web && rails s"
similiarity: sh -c "cd SimilarityAlgo && python app.py"
worker: sh -c "cd Web && bundle exec sidekiq -q default -q mailers"

## Enable if you want to run locally
#postgres: postgres -D /usr/local/var/postgresg