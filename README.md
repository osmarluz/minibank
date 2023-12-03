# Minibank
> This is a simple application that deals with receiving payments from an external source and computing the resulting balances that I did to try out using railway oriented programming, functional programming and the dry-rb gems.

![minibank](https://github.com/osmarluz/minibank/assets/29878826/ca87bb22-2e2f-4aad-87b2-89250e5bca96)

![ruby](https://img.shields.io/badge/Ruby-3.2.2-red.svg)
![rails](https://img.shields.io/badge/Rails-7.1.2-red.svg)

## Development Setup

### 1. Build the containers

`docker-compose build`

### 2. Create the database on the container

`docker-compose run --rm app bundle exec rails db:create`

### 3. Run the database migrations on the app database

`docker-compose run --rm app bundle exec rails db:migrate`

### 4. Build the assets

#### 4.1 CSS

`docker-compose run --rm app bundle exec rails css:build`

#### 4.2. Javascript

`docker-compose run --rm app bundle exec yarn build`

### 6. Start the containers

`docker-compose up`

## Test Execution

### 1. Run the database migrations on the test database

`docker-compose run --rm app bundle exec rails db:migrate`

### 2. Run the tests

`docker-compose run --rm app bundle exec rspec`
