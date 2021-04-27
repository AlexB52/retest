require 'test_helper'

module Retest
  class OptionsTest < MiniTest::Test
    def setup
      @subject = Options.new
    end

    def test_auto?
      @subject.args = ['--auto']
      assert @subject.auto?

      @subject.args = ['--rspec']
      refute @subject.auto?

      @subject.args = []
      assert @subject.auto?
    end

    def test_full_suite?
      refute @subject.full_suite?
      @subject.args = ["--all"]
      assert @subject.full_suite?
    end

    def test_help?
      @subject.args = ["--help"]
      assert @subject.help?

      @subject.args = ["--rake", "-h"]
      assert @subject.help?
    end

    def test_help_text
      assert_equal File.read('test/retest/options/help.txt'), @subject.help
    end
  end
end