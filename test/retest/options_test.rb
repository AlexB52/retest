require 'test_helper'

module Retest
  class OptionsTest < MiniTest::Test
    def setup
      @subject = Options.new
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

    def test_default_options
      @subject.args = ["echo hello world"]

      assert_equal 'echo hello world', @subject.command
    end

    def test_empty_options
      @subject.args = []

      assert_equal 'echo You have no command assigned', @subject.command
    end

    def test_mixed_options
      @subject.args = ["echo hello world", "--rails"]

      assert_equal 'bundle exec rails test <test>', @subject.command

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