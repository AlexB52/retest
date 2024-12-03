FROM rust:1.83.0-slim-bullseye

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git ruby ruby-dev

RUN cargo install watchexec-cli
RUN watchexec --version

# throw errors if Gemfile has been modified since Gemfile.lock
RUN gem install bundler
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

COPY Gemfile Gemfile.lock retest.gem ./

RUN bundle config --delete frozen
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["retest", "--ruby"]