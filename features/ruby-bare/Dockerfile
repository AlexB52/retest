FROM ruby:2.4.1-alpine

ARG BUILD_PACKAGES="build-base git"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8

COPY retest.gem ./
RUN gem install retest.gem
RUN gem install minitest

COPY . /usr/src/app

CMD ["retest", "--ruby"]