[![Gem Version](https://badge.fury.io/rb/retest.svg)](https://badge.fury.io/rb/retest)

### Retest 2.0 is now available!

Feedback is welcome in this [Discussion - Retest V2.0 - Interactive Panel (proof of concept)](https://github.com/AlexB52/retest/discussions/216)

# Retest

A trusty CLI companion to monitor file changes and automatically run the corresponding Ruby specs. Ready to assist on any Ruby project, no setup needed! Designed to be dev-centric and project independent, it can be used on the fly. No Gemfile updates, no commits to a repo or configuration files required to start refactoring. Works with every Ruby projects (at least that is the end goal)

## Demo

https://user-images.githubusercontent.com/7149034/153734043-1d136f27-5c24-4676-868b-0fde76016b13.mp4

## Installation

Install it on your machine without adding it on a Gemfile:

    $ gem install retest

## Ruby Support

Retest supports ruby 2.5 and above.

## Watching tools: Watchexec & Listen

By default retest ships with [Listen](https://github.com/guard/listen) which is used to listen to file changes. 

Retest will use [watchexec](https://github.com/watchexec/watchexec) a more performant file watcher when installed on the matchine. watchexec will only work with a version >= 2.2.0

To force the usage of a watcher you can use the `-w` option as `retest -w watchexec`

## Usage

Retest is used in your terminal after accessing your ruby project folder.

### Help

Find out what retest can do anytime with

    $ retest -h

Here is a quick summary:

  * run a hardcoded command: `retest 'bin/rails test test/models/post_test.rb'`
  * use placeholders: `retest 'bin/rails test <test> && rubocop <changed>`
  * play a sound for feedback: `retest --notify`
  * run all specs when a file change: `retest --all`
  * run all matching specs from a diffed branch: `retest --diff origin/main`

### Interactive companion

An interactive shell will start when launching retest to help your testing workflow. Enter 'h' to see all the options.

```
Setup identified: [RAKE]. Using command: 'bundle exec rake test TEST=<test>'
Watcher: [WATCHEXEC]
Launching Retest...
Ready to refactor! You can make file changes now

Type interactive command and press enter. Enter 'h' for help.
> h

* 'h', 'help'              # Prints help.
* 'p', 'pause'             # Pauses Retest. Tests aren't run on file change events until unpaused.
* 'u', 'unpause'           # Unpauses Retest.
* <ENTER>                  # Runs last changed triggered command.
* 'ra, 'run all'           # Runs all tests.
* 'f', 'force'             # Forces a selection of test to run on every file change.
* 'r', 'reset'             # Disables forced selection.
* 'd', 'diff' [GIT BRANCH] # Runs matching specs that changed from a target branch.
* 'c'                      # Clears window.
* 'e', 'exit'              # Exits Retest.

```
### Running rules

When on a forced selection, retest will run the forced selection regardless of the file changed.

Otherwise, the gem works as follows:

* When a **ruby file** is changed, retest will run its matching test.
* When a **test file** is changed, retest will run the test file.
* When multiple matching test files are found, retest asks you to confirm the file and save the answer.
* When a test file is not found, retest runs the last run command or throw a 404.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run integration tests on one setup (ex: hanami-app): `bin/test/hanami-app`

To access an app container (ex: ruby-app): `docker-compose -f features/ruby-app/docker-compose.yml run retest sh`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexb52/retest.


## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
