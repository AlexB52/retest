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
      @subject.args = ["--exts rb"]

      assert_equal %w[rb], @subject.extensions

      @subject.args = ["--exts rb,js, html,css ,ts"]

      assert_equal %w[rb js html css ts], @subject.extensions
    end

    def test_all_version_copy
      @subject.args = %w[--notify --rake]

      copy = @subject.merge(%w[--all])

      assert_equal %w[--notify --rake --all], copy.args
      refute_equal copy.object_id, @subject.object_id
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

      @subject.args = %w[-w hello]
      assert_equal :installed, @subject.watcher

      @subject.args = %w[] # default when no listeners are install by default
      assert_equal :installed, @subject.watcher
    end
  end
end