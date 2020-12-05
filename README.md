# Retest

Retest is a small command-line tool to help you refactor code by watching a file change and running its matching spec. Designed to be dev-centric and project independent, it can be used on the fly. No Gemfile updates, no commits to a repo or configuration files required to start refactoring. Works with every Ruby projects (at least that is the end goal)

## Why?
It is advised to be one `cmd + z` away from green tests when refactoring. This means running tests after every line change. Let Retest rerun your tests after every file change you make.

Retest gem is meant to be simple and follow testing conventions encountered in Ruby projects. Give it a go you can uninstall it easily. If you think the matching pattern could be improved please raise an issue.

For fully fledged solutions, some cli tools already exists: [autotest](https://github.com/grosser/autotest), [guard](https://github.com/guard/guard), [zentest](https://github.com/seattlerb/zentest)

![demo](https://alexbarret.com/images/external/retest-demo-26bcad04.gif)

## Installation

Install it on your machine with:

    $ gem install retest
    $ retest 'bundle exec rspec <test>'

## Usage

Launch `retest` in your terminal after accessing your ruby project folder.

Pass the test command surrounded by quotes. Use the placeholder `<test>` in your command to let `retest` find the matching test and replace the placeholder with the path of the test file.

Learn more by running `retest -h`

```bash
Usage: retest  [OPTIONS] [COMMAND]

Watch a file change and run it matching spec.

Arguments:
  COMMAND  The test command to rerun when a file changes.
           Use <test> placeholder to tell retest where to put the matching
           spec.


Options:
      --all    Run all the specs of a specificied ruby setup
  -h, --help   Print usage
      --rails  Shortcut for 'bundle exec rails test <test>'
      --rake   Shortcut for 'bundle exec rake test TEST=<test>'
      --rspec  Shortcut for 'bundle exec rspec <test>'
      --ruby   Shortcut for 'bundle exec ruby <test>'

Examples:
  Runs a matching rails test after a file change
    $ retest 'bundle exec rails test <test>'
    $ retest --rails

  Runs all rails tests after a file change
    $ retest 'bundle exec rails test'
    $ retest --rails --all

  Runs a hardcoded command after a file change
    $ retest 'ruby lib/bottles_test.rb'
```

The gem works as follows:

* When a file is changed, retest will run its matching file test.
* When a test file is changed, retest will run the file test.
* When multiple matching test files are found, retest asks you to confirm the file and save the answer.
* When a test file is not found, retest runs the last run command or throw a 404.

### Docker

Retest works in Docker too. You can install the gem and launch retest in your container while refactoring.
```bash
$ docker-compose run web bash # enter your container
$ gem install retest
$ retest 'bundle exec rails test <test>'
```

### Disclaimer
* If an error comes in try using `bundle exec` like so: `$ retest 'bundle exec rake test <test>'`
* Aliases saved on ~/.bashrc or ~/.zshrc cannot be run that way with the `retest` command

## Ruby Support

Retest supports ruby 2.4 and above.

## Roadmap

- [x] MVP
- [x] When multiple test files are found, ask which file to run and save the answer.
- [x] When a test file is not found run the last command again.
- [x] Run within Docker.
- [ ] Handle main Ruby setups
  - [x] Bundler Gem
  - [x] Rails
  - [x] Ad-hoc scripts
  - [x] Hanami
  - [ ] Sinatra
  - [ ] Cuba? Padrino?
- [ ] Handle other languages: Elixir, Node, Python, PHP
- [ ] Aliases from oh-my-zsh and bash profiles?

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexb52/retest.


## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
