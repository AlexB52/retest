FROM ruby:2.5.9-alpine3.13

ARG BUILD_PACKAGES="build-base git"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

ENV LANG C.UTF-8

COPY retest.gem ./
RUN gem update --system 3.2.3
RUN gem install retest.gem
RUN gem install minitest -v 5.15.0 # minitest doesn't support some ruby versions

COPY . /usr/src/app

CMD ["retest", "--ruby"]