#!/bin/bash --login

bundle check || bundle install

#entrypoint for docker
if [ "$1" = 'default' ]; then
  echo 'Starting web server...'

  rm -rf tmp/pids/server.pid
  bundle exec rails s -b '0.0.0.0' -p 8000
else
  bundle exec "$@"
fi
