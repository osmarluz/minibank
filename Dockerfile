FROM ruby:3.2.2-slim

ARG BUNDLER_VERSION=2.4

ARG RAILS_PORT
ARG RAILS_ENV

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    wait-for-it \
    tzdata \
    libpq-dev \
    imagemagick \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn

RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN echo 'America/Sao_Paulo' > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
ARG TZ_DATA

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=$(nproc) \
  BUNDLE_RETRY=5

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app
