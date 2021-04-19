require 'test_helper'

module Retest
  class OptionsCommandTest < MiniTest::Test
    def setup
      @subject = Command.new
    end

    def test_hardcoded_command
      @subject.options = Options.new(['--rspec', '--all', 'hello world'])
      assert_equal 'hello world', @subject.options_command
    end

    def test_matching_test_options
      @subject.options = Options.new(['--rspec'])
      assert_equal 'bundle exec rspec <test>', @subject.options_command

      @subject.options = Options.new(['--rails'])
      assert_equal 'bundle exec rails test <test>', @subject.options_command

      @subject.options = Options.new(['--ruby'])
      assert_equal 'bundle exec ruby <test>', @subject.options_command

      @subject.options = Options.new(['--rake'])
      assert_equal 'bundle exec rake test TEST=<test>', @subject.options_command
    end

    def test_all_options
      @subject.options = Options.new(['--rspec', '--all'])
      assert_equal 'bundle exec rspec', @subject.options_command

      @subject.options = Options.new(['--rails', '--all'])
      assert_equal 'bundle exec rails test', @subject.options_command

      @subject.options = Options.new(['--rake', '--all'])
      assert_equal 'bundle exec rake test', @subject.options_command
    end
  end

  class SetupCommandTest < MiniTest::Test
    FakeSetup = Struct.new(:type)

    def setup
      @subject = Command.new
    end

    def test_setup_command_with_rake
      @subject.setup = FakeSetup.new(:rake)
      assert_equal 'bundle exec rake test TEST=<test>', @subject.setup_command
    end

    def test_setup_command_with_rails
      @subject.setup = FakeSetup.new(:rails)
      assert_equal 'bundle exec rails test <test>', @subject.setup_command
    end

    def test_setup_command_with_rspec
      @subject.setup = FakeSetup.new(:rspec)
      assert_equal 'bundle exec rspec <test>', @subject.setup_command
    end

    def test_setup_command_with_ruby
      @subject.setup = FakeSetup.new(:ruby)
      assert_equal 'bundle exec ruby <test>', @subject.setup_command
    end
  end
end