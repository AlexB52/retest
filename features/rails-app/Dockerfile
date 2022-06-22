FROM ruby:2.4.10-alpine

ARG BUILD_PACKAGES="build-base git nodejs tzdata sqlite-dev"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1

COPY Gemfile Gemfile.lock retest.gem ./
RUN gem install bundler -v 2.1.4
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["bin/setup"]
