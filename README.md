[![Gem Version](https://badge.fury.io/rb/retest.svg)](https://badge.fury.io/rb/retest)

# Retest

Retest is a small command-line tool to help you refactor code by watching a file change and running its matching spec. Designed to be dev-centric and project independent, it can be used on the fly. No Gemfile updates, no commits to a repo or configuration files required to start refactoring. Works with every Ruby projects (at least that is the end goal)

## Demo

![demo](https://alexbarret.com/images/external/retest-demo-26bcad04.gif)

## Installation

Install it on your machine without adding it on a Gemfile:

    $ gem install retest

## Usage

Retest is used in your terminal after accessing your ruby project folder.

### For Refactoring

#### 1. Run a hardcoded command

This the most simple usage of retest: running the same command over and over after each file update.

    $ retest 'bundle exec rspec spec/features/posts_spec.rb'

In this example, the feature spec `spec/features/posts_spec.rb` will be tested after any ruby file is updated.

#### 2. Run a dynamic command

You can use the placeholder `<test>` to tell the gem where to put the test file path in your command. 

Example:

    $ retest 'bin/rails test <test>'

When a file is changed, the gem will find its matching test and run the test command with it. 
If `app/models/post.rb` is changed then retest will run `bin/rails test test/models/post_test.rb`

#### 3. Run a dynamic command with shortcuts

Few shortcut flags exist to avoid writing the full test command.

    $ retest --rspec
    $ retest --rails
    $ retest --rake --all

#### 4. Let retest figure it all out

Let retest find your ruby setup and run the appropriate command using:

    $ retest
    $ retest --all

#### Running rules

The gem works as follows:

* When a **ruby file** is changed, retest will run its matching test.
* When a **test file** is changed, retest will run the test file.
* When multiple matching test files are found, retest asks you to confirm the file and save the answer.
* When a test file is not found, retest runs the last run command or throw a 404.

### Pull request scans

You can diff a branch and test all the relevant test files before pushing your branch and trigger a full CI suite. 

    $ retest --diff origin/main

In this example, retest lists all the files changed between `HEAD` and `origin/main`, finds all the relevant tests and only run those.

### Help

See more examples with `retest -h`

```
Usage: retest  [OPTIONS] [COMMAND]

Watch a file change and run it matching spec.

Arguments:
  COMMAND  The test command to rerun when a file changes.
           Use <test> placeholder to tell retest where to put the matching
           spec.
           

Options:
      --all              Run all the specs of a specificied ruby setup
      --auto             Indentify repository setup and runs appropriate
                         command
      --diff=git-branch  Pipes all matching tests from diffed branch to test
                         command
  -h, --help             Print usage
      --rails            Shortcut for a standard Rails setup
      --rake             Shortcut for a standard Rake setup
      --rspec            Shortcut for a standard RSpec setup
      --ruby             Shortcut for a Ruby project

Examples:
  Runs a matching rails test after a file change
    $ retest 'bundle exec rails test <test>'
    $ retest --rails

  Runs all rails tests after a file change
    $ retest 'bundle exec rails test'
    $ retest --rails --all

  Runs a hardcoded command after a file change
    $ retest 'ruby lib/bottles_test.rb'

  Let retest identify which command to run
    $ retest
    $ retest --auto

  Let retest identify which command to run for all tests
    $ retest --all
    $ retest --auto --all

  Run a sanity check on changed files from a branch
    $ retest --diff origin/main --rails
    $ retest --diff main --auto
```

## Why?
It is advised to be one `cmd + z` away from green tests when refactoring. This means running tests after every line change. Let Retest rerun your tests after every file change you make.

Retest gem is meant to be simple and follow testing conventions encountered in Ruby projects. Give it a go you can uninstall it easily. If you think the matching pattern could be improved please raise an issue.

For fully fledged solutions, some cli tools already exists: [autotest](https://github.com/grosser/autotest), [guard](https://github.com/guard/guard), [zentest](https://github.com/seattlerb/zentest)

## Docker

Retest works in Docker too. You can install the gem and launch retest in your container while refactoring.

```bash
# Enter your container. Ex:
$ docker-compose run web bash

# Install the gem and run retest in your container shell
$ gem install retest
$ retest 'bundle exec rails test <test>'
```

## Disclaimer
* If an error comes in try using `bundle exec` like so: `$ retest 'bundle exec rake test <test>'`
* Aliases saved on ~/.bashrc or ~/.zshrc cannot be run that way with the `retest` command

## Ruby Support

Retest supports ruby 2.4 and above.

## Roadmap

- [x] MVP
- [x] When multiple test files are found, ask which file to run and save the answer.
- [x] When a test file is not found run the last command again.
- [x] Run within Docker.
- [x] Handle main Ruby setups
  - [x] Bundler Gem
  - [x] Rails
  - [x] Ad-hoc scripts
  - [x] Hanami
- [ ] Handle other languages: Go, Elixir, Node, Python, PHP
  - [ ] Go (project started)
- [ ] Aliases from oh-my-zsh and bash profiles?

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run integration tests on one setup (ex: hanami-app): `bin/test/hanami-app`

To access an app container (ex: ruby-app): `docker-compose -f features/ruby-app/docker-compose.yml run retest sh`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexb52/retest.


## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
