FROM ruby:2.6.3

RUN apt-get update -qq \
  && apt-get upgrade -y \
  && apt-get install -y build-essential imagemagick mariadb-client apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}

RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY . /app
WORKDIR /app

RUN gem install bundler && gem cleanup && bundle install
