FROM ruby:2.5.9-alpine3.13

ARG BUILD_PACKAGES="build-base git sqlite-dev"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 1.17.3

COPY Gemfile Gemfile.lock retest.gem ./
RUN gem update --system 3.2.3
RUN gem install bundler -v 1.17.3
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["bin/test_setup"]
