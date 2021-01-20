FROM ruby:3-alpine AS development
RUN apk add --no-cache make g++

WORKDIR /tmp
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock

# Use a controlled bundler version
ENV BUNDLER_VERSION 2.2.5
RUN gem install bundler -v ${BUNDLER_VERSION} && \
    bundle config set without 'development test' && \
    bundle config set deployment 'true' && \
    bundle config set path ${GEM_HOME} && \
    bundle install -j 8

RUN apk del make g++

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

FROM development AS test
# Add the whole application
COPY . /usr/src/app

# See https://docs.docker.com/develop/develop-images/multistage-build/
FROM test AS production

CMD ["ruby", "main.rb"]
