FROM ruby:2.6.3

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}

RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY . /app
WORKDIR /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN apt-get update -qq \
  && apt-get upgrade -y \
  && apt-get install -y build-essential imagemagick mysql-client apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

RUN curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs

RUN gem install bundler && gem cleanup && bundle install

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
