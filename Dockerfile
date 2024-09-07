FROM ruby:3.3.5

RUN apt-get update -qq && apt-get upgrade -y \
  && apt-get install -y build-essential imagemagick mariadb-client apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
