require 'test_helper'

module Retest
  class TestWatcher < Minitest::Test
    def test_for
      assert_equal Watcher::Default, Watcher.for('listen')
      assert_equal Watcher::Watchexec, Watcher.for('watchexec')
      assert_equal Watcher::Watchexec, Watcher.for(nil)

      assert_raises(ArgumentError) { Watcher.for('fswatch') }
    end
  end

  module Watcher
    class TestDefault < Minitest::Test
      def test_installed?
        assert Default.installed?
      end

      def test_extensions_regex
        result = Default.extensions_regex(%w[rb html])

        assert result.match? "a/file/path.rb"
        refute result.match? "a/file/path.js"
        assert result.match? "a/file/path.html"
        refute result.match? "a/file/path.css"
        refute result.match? "a/file/path.ts"

        result = Default.extensions_regex(%w[rb js html css ts])

        assert result.match? "a/file/path.rb"
        assert result.match? "a/file/path.js"
        assert result.match? "a/file/path.html"
        assert result.match? "a/file/path.css"
        assert result.match? "a/file/path.ts"
      end
    end

    class TestWatchexec < Minitest::Test
      def test_installed?
        # Installed on the machine
        assert Watchexec.installed?
      end
    end
  end
end