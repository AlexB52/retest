FROM ruby:2.4.1-alpine

ARG BUILD_PACKAGES="build-base git"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

COPY Gemfile Gemfile.lock retest.gem ./
RUN gem install bundler -v 2.1.4
RUN bundle config --delete frozen
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["retest", "--ruby"]