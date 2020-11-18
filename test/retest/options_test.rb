require 'test_helper'

module Retest
  class OptionsTest < MiniTest::Test
    def setup
      @subject = Options.new
    end

    def test_rake_flag
      @subject.args = %w(--rake)

      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
    end

    def test_rspec_flag
      @subject.args = %w(--rspec)

      assert_equal 'bundle exec rspec <test>', @subject.command
    end

    def test_rails_flag
      @subject.args = %w(--rails)

      assert_equal 'bundle exec rails test <test>', @subject.command
    end

    def test_help
      assert_equal <<~HELP, @subject.help
        Usage: retest options [OPTIONS]

        Watch a file change and run it matching spec

        Options:
          --rails  Shortcut for 'bundle exec rails test <test>'
          --rake   Shortcut for 'bundle exec rake test TEST=<test>'
          --rspec  Shortcut for 'bundle exec rspec <test>'

        Examples:
          Runs a matching rails test after a file change
            $ retest 'bundle exec rails test <test>'
            $ retest --rails

          Runs all rails tests after a file change
            $ retest 'bundle exec rails test'

          Runs a hardcoded command after a file change
            $ retest 'ruby lib/bottles_test.rb'
      HELP
    end
  end
end