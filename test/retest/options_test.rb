require 'test_helper'
require_relative 'options/auto_flag'

module Retest
  class OptionsTest < MiniTest::Test
    def setup
      @subject = Options.new(output_stream: StringIO.new)
    end

    def test_default_options
      @subject.args = ["echo hello world"]

      assert_equal 'echo hello world', @subject.command
    end

    def test_empty_options
      @subject.args = []
      expected_command = Options.new(['--auto'], output_stream: StringIO.new).command

      assert_equal expected_command, @subject.command
    end

    def test_auto_options
      # returning the gem setup in this test
      @subject.args = ['--auto']

      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
    end

    def test_rake_flag
      @subject.args = ['--rake']

      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
    end

    def test_rspec_flag
      @subject.args = ['--rspec']

      assert_equal 'bundle exec rspec <test>', @subject.command
    end

    def test_rails_flag
      @subject.args = ['--rails']

      assert_equal 'bundle exec rails test <test>', @subject.command
    end

    def test_ruby_flag
      @subject.args = ['--ruby']

      assert_equal 'bundle exec ruby <test>', @subject.command
    end

    def test_all_flag
      @subject.args = ['--rake', '--all']

      assert_equal 'bundle exec rake test', @subject.command

      @subject.args = ['--rails', '--all']

      assert_equal 'bundle exec rails test', @subject.command

      @subject.args = ['--rspec', '--all']

      assert_equal 'bundle exec rspec', @subject.command

      @subject.args = ['--ruby', '--all']

      assert_equal 'bundle exec ruby <test>', @subject.command
    end

    def test_mixed_options
      @subject.args = ["echo hello world", "--rails"]

      assert_equal 'echo hello world', @subject.command

      @subject.args = ["--rspec", "--rails"]

      assert_equal 'bundle exec rspec <test>', @subject.command
    end

    def test_help_flag
      @subject.args = ["--help"]

      assert @subject.params[:help]

      @subject.args = ["-h"]

      assert @subject.params[:help]
    end

    def test_help_text
      assert_equal File.read('test/retest/options/help.txt'), @subject.help
    end

    def test_help?
      refute @subject.help?

      @subject.args = ["--help"]

      assert @subject.help?

      @subject.args = ["--rake", "-h"]

      assert @subject.help?
    end
  end
end