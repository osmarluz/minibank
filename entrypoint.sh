#!/bin/bash -i

# Remove a potentially pre-existing server.pid for Rails.
rm -rf /app/tmp/pids/server.pid /app/tmp/pids/sidekiq.pid

# Checks if the dependencies listed in Gemfile are satisfied by currently installed gems
bundle clean --force

# Check whether or not gems are installed, and install it case not installed.
bundle check || bundle install --jobs=$(nproc) --retry=5

wait-for-it postgres:5432 -- "$@"
