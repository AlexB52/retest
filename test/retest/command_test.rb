require 'test_helper'
require_relative 'command/auto_flag'

module Retest
  class OptionsCommandTest < MiniTest::Test
    def setup
      @subject = Command.new
    end

    def test_retest_repository_setup
      # returning the gem setup in this test
      @subject.options = Options.new([])

      assert_equal Command::Rake.new(all: false), @subject.command
    end

    def test_hardcoded_command
      @subject.options = Options.new(["echo 'hello world'"])

      assert_equal Command::Hardcoded.new(command: "echo 'hello world'"), @subject.command
    end

    def test_matching_test_options
      @subject.options = Options.new(['--rspec'])
      assert_equal Command::Rspec.new(all: false), @subject.command

      @subject.options = Options.new(['--rails'])
      assert_equal Command::Rails.new(all: false), @subject.command

      @subject.options = Options.new(['--ruby'])
      assert_equal Command::Ruby.new(all: false), @subject.command

      @subject.options = Options.new(['--rake'])
      assert_equal Command::Rake.new(all: false), @subject.command
    end

    def test_all_options
      @subject.options = Options.new(['--rspec', '--all'])
      assert_equal Command::Rspec.new(all: true), @subject.command

      @subject.options = Options.new(['--rails', '--all'])
      assert_equal Command::Rails.new(all: true), @subject.command

      @subject.options = Options.new(['--rake', '--all'])
      assert_equal Command::Rake.new(all: true), @subject.command

      @subject.options = Options.new(['--ruby', '--all'])
      assert_equal Command::Ruby.new(all: true), @subject.command
    end

    def test_alias_options
      @subject.options = Options.new(["--rails", "bin/test"])
      assert_equal Command::Rails.new(command: "bin/test"), @subject.command

      @subject.options = Options.new(["--rspec", "bin/test"])
      assert_equal Command::Rspec.new(command: "bin/test"), @subject.command

      @subject.options = Options.new(["--rake", "bin/test"])
      assert_equal Command::Rake.new(command: "bin/test"), @subject.command

      @subject.options = Options.new(["--ruby", "bin/test"])
      assert_equal Command::Ruby.new(command: "bin/test"), @subject.command
    end

    def test_invalid_options
      @subject.options = Options.new(["--rspec", "--rails"])
      assert_equal Command::Rspec.new(all: false), @subject.command
    end
  end

  class SetupCommandTest < MiniTest::Test
    FakeSetup = Struct.new(:type)

    def setup
      @subject = Command.new
    end

    def test_setup_command_with_rake
      @subject.setup = FakeSetup.new(:rake)
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command.to_s
    end

    def test_setup_command_with_rails
      @subject.setup = FakeSetup.new(:rails)
      assert_equal 'bundle exec rails test <test>', @subject.command.to_s
    end

    def test_setup_command_with_rspec
      @subject.setup = FakeSetup.new(:rspec)
      assert_equal 'bundle exec rspec <test>', @subject.command.to_s
    end

    def test_setup_command_with_ruby
      @subject.setup = FakeSetup.new(:ruby)
      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
    end
  end
end