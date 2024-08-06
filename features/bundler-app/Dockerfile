FROM ruby:3.1.2-alpine

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

COPY . /usr/src/app
RUN gem update --system 3.2.3
RUN gem install bundler
RUN bundle
RUN gem install retest.gem
RUN git init

CMD ["retest", "--ruby"]