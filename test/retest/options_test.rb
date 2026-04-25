require 'test_helper'

module Retest
  class OptionsTest < Minitest::Test
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

    def test_diff
      @subject.args = %w[--diff main]
      assert_equal "main", @subject.params[:diff]

      @subject.args = %w[--diff=origin/main]
      assert_equal "origin/main", @subject.params[:diff]
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

    def test_extensions
      @subject.args = ["--exts", "rb"]

      assert_equal %w[rb], @subject.extensions

      @subject.args = ["--exts", "rb,js, html,css ,ts"]

      assert_equal %w[rb js html css ts], @subject.extensions
    end

    def test_all_version_copy
      @subject.args = %w[--notify --rake]

      copy = @subject.merge(%w[--all])

      assert_equal %w[--notify --rake --all], copy.args
      refute_equal copy.object_id, @subject.object_id
    end

    def test_command_is_positional_after_options
      @subject.args = ["--rails", "--all", "bin/test"]

      assert_equal "bin/test", @subject.command
      assert @subject.full_suite?
      assert @subject.params[:rails]
    end

    def test_command_with_flags_after_it
      @subject.args = ["--rails", "bin/test", "--all"]

      assert_equal "bin/test", @subject.command
      assert @subject.full_suite?
      assert @subject.params[:rails]
    end

    def test_command_with_option_value_after_it
      @subject.args = ["bin/test", "--watcher", "watchexec", "--diff", "origin/main"]

      assert_equal "bin/test", @subject.command
      assert_equal :watchexec, @subject.watcher
      assert_equal "origin/main", @subject.params[:diff]
    end

    def test_command_with_unknown_flags_after_it_raises
      error = assert_raises(OptionParser::ParseError) do
        @subject.args = ["bin/test", "--unknown"]
      end

      assert_equal "invalid option: --unknown", error.message
    end

    def test_unknown_options_raise
      error = assert_raises(OptionParser::ParseError) do
        @subject.args = ["--unknown", "--notify", "bin/test"]
      end

      assert_equal "invalid option: --unknown", error.message
    end

    def test_listener
      @subject.args = %w[--watcher=watchexec]
      assert_equal :watchexec, @subject.watcher

      @subject.args = %w[-w watchexec]
      assert_equal :watchexec, @subject.watcher

      @subject.args = %w[--watcher=listen]
      assert_equal :listen, @subject.watcher

      @subject.args = %w[-w listen]
      assert_equal :listen, @subject.watcher

      error = assert_raises(OptionParser::ParseError) do
        @subject.args = %w[-w hello]
      end

      assert_equal "invalid argument: -w hello", error.message

      @subject.args = %w[] # default when no listeners are install by default
      assert_equal :installed, @subject.watcher
    end
  end
end
