FROM ruby:2.7-slim-bullseye

# Install necessary dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy watchexec from the Rust stage
COPY --from=ghcr.io/alexb52/slim-bullseye-watchexec:latest /usr/local/cargo/bin/watchexec /usr/local/bin/watchexec

# Verify watchexec installation in the final image
RUN watchexec --version

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

COPY Gemfile Gemfile.lock retest.gem ./
RUN gem update --system 3.2.3
RUN gem install bundler -v 2.1.4
RUN bundle config --delete frozen
RUN bundle install
RUN gem install retest.gem

COPY . /usr/src/app

CMD ["retest", "--ruby"]