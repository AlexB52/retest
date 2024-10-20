
FROM ruby:2.7.8-alpine3.16

ARG BUILD_PACKAGES="build-base git nodejs tzdata sqlite-dev"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1

COPY Gemfile Gemfile.lock retest.gem ./
RUN gem update --system 3.2.3
RUN gem install bundler -v 2.1.4
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["bin/setup"]
