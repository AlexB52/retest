# Retest

Retest is a small command line tool to help refactor code by watching a file change and running its matching spec. You don't need to add it in your Gemfile or set a configuration file to start refactoring.

## Why?
It is advised to be one `cmd + z` away from green tests when refactoring. This means running tests after every line change. Let Retest rerun your tests after every file change you make.

Retest gem is meant to be simple and follow testing conventions encountered in Ruby projects. It is probably unstable and unflexible. Give it a go you can uninstall it easily. If you think the matching pattern could be improved please raise an issue.

For stable, yet more and fully fledged solutions, some cli tools already exists: [autotest](https://github.com/grosser/autotest), [guard](https://github.com/guard/guard), [zentest](https://github.com/seattlerb/zentest)

![demo](https://alexbarret.com/images/external/retest-demo-26bcad04.gif)

## Installation

Install it on your machine with:

    $ gem install retest

## Usage

Launch `retest` in your terminal after accessing your ruby project folder.

Pass the test command surrounded with quotes. Use the placeholder `<test>` in your command to let `retest` find the matching test and replace the placeholder with the path of the test file.

```bash
# Let retest find the test file and replace the placeholder with the path of the test file
$ retest 'bundle exec rake test TEST=<test>'
$ retest 'rails test <test>'
$ retest 'rspec <test>'
$ retest 'ruby <test>'
$ retest 'docker-compose exec web bundle exec rails test <test>'

# Run the same command after a file change like all the spec files
$ retest 'bundle exec rake test'
$ retest 'rails test'
$ retest 'rspec'
$ retest 'docker-compose exec web bundle exec rails test'

# Hardcode a test file to run indepdendently from the file you change
$ retest 'ruby all_tests.rb'
```

The gem works as follows:

* When multiple matching test files are found, the tool asks you to confirm the file and save the answer.
* When a test file is not found run the last command again. If no command was run before nothing gets run.
* Works with RSpec, MiniTest, Rake commands & bash commands (not aliases).
* Works when installed and run in a Docker container.

### Docker

Installing & launching the gem in a Docker container seems to work
```bash
$ docker-compose run web bash
$ gem install retest
$ retest 'bundle exec rails test <test>'
```

**Disclaimer:**
* If an error comes in try using `bundle exec` like so: `$ retest 'bundle exec rake test <test>'`
* Aliases saved on ~/.bashrc or ~/.zshrc cannot be run that way with the `retest` command

## Roadmap

- [x] MVP
- [x] When multiple test files are found, ask  which file to run and save the answer.
- [x] When a test file is not found run the last command again.
- [x] Run within Docker.
- [ ] Aliases from oh-my-zsh and bash profiles?

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexb52/retest.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
