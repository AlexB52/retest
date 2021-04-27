require 'test_helper'
require_relative 'command/auto_flag'
require_relative 'command/setup_commands'

module Retest
  class OptionsCommandTest < MiniTest::Test
    def setup
      @subject = Command.new output_stream: StringIO.new
    end

    def test_hardcoded_command
      @subject.options = Options.new(['--rspec', '--all', 'hello world'])
      assert_equal 'hello world', @subject.command
    end

    def test_empty_options
      # returning the gem setup in this test
      @subject.options = Options.new([])
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command

      @subject.options = Options.new(['--auto'])
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
    end

    def test_matching_test_options
      @subject.options = Options.new(['--rspec'])
      assert_equal 'bundle exec rspec <test>', @subject.command

      @subject.options = Options.new(['--rails'])
      assert_equal 'bundle exec rails test <test>', @subject.command

      @subject.options = Options.new(['--ruby'])
      assert_equal 'bundle exec ruby <test>', @subject.command

      @subject.options = Options.new(['--rake'])
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
    end

    def test_all_options
      @subject.options = Options.new(['--rspec', '--all'])
      assert_equal 'bundle exec rspec', @subject.command

      @subject.options = Options.new(['--rails', '--all'])
      assert_equal 'bundle exec rails test', @subject.command

      @subject.options = Options.new(['--rake', '--all'])
      assert_equal 'bundle exec rake test', @subject.command

      @subject.options = Options.new(['--ruby', '--all'])
      assert_equal 'bundle exec ruby <test>', @subject.command
    end

    def test_mixed_options
      @subject.options = Options.new(["echo hello world", "--rails"])
      assert_equal 'echo hello world', @subject.command

      @subject.options = Options.new(["--rspec", "--rails"])
      assert_equal 'bundle exec rspec <test>', @subject.command
    end
  end

  class SetupCommandTest < MiniTest::Test
    FakeSetup = Struct.new(:type)

    def read_output
      @output.tap(&:rewind).read
    end

    def setup
      @output = StringIO.new
      @subject = Command.new output_stream: @output
    end

    def test_setup_command_with_rake
      @subject.setup = FakeSetup.new(:rake)
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
      assert_equal %Q{Setup identified: [RAKE]. Using command: 'bundle exec rake test TEST=<test>'\n}, read_output
    end

    def test_setup_command_with_rails
      @subject.setup = FakeSetup.new(:rails)
      assert_equal 'bundle exec rails test <test>', @subject.command
      assert_equal %Q{Setup identified: [RAILS]. Using command: 'bundle exec rails test <test>'\n}, read_output
    end

    def test_setup_command_with_rspec
      @subject.setup = FakeSetup.new(:rspec)
      assert_equal 'bundle exec rspec <test>', @subject.command
      assert_equal %Q{Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'\n}, read_output
    end

    def test_setup_command_with_ruby
      @subject.setup = FakeSetup.new(:ruby)
      assert_equal 'bundle exec ruby <test>', @subject.command
      assert_equal %Q{Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'\n}, read_output
    end
  end
end