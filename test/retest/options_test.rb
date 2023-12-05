require 'test_helper'

module Retest
  class OptionsTest < MiniTest::Test
    def setup
      @subject = Options.new
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

    def test_force_polling?
      @subject.args = []
      refute @subject.force_polling?

      @subject.args = ["--polling"]
      assert @subject.force_polling?
    end

    def test_help_text
      assert_equal File.read('test/retest/options/help.txt'), @subject.help
    end

    def test_version?
      @subject.args = ["--version"]
      assert @subject.version?

      @subject.args = ["-v"]
      assert @subject.version?

      @subject.args = ["-h"]
      refute @subject.version?
    end

    def test_notify?
      refute @subject.notify?
      @subject.args = ["--notify"]
      assert @subject.notify?
    end
  end
end