FROM ruby:2.4.1-alpine

ARG BUILD_PACKAGES="build-base git sqlite-dev"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 1.17.3

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 1.17.3
RUN bundle install
RUN gem install retest

COPY . /usr/src/app

CMD ["bundle", "exe", "rake"]
