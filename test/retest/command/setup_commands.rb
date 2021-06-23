module Retest
  class Command
    class RakeTest < MiniTest::Test
      def test_command
        assert_equal 'bin/rake test',                     Rake.command(all: true, file_system: FakeFS.new(['bin/rake']))
        assert_equal 'bundle exec rake test',             Rake.command(all: true, file_system: FakeFS.new([]))
        assert_equal 'bin/rake test TEST=<test>',         Rake.command(all: false, file_system: FakeFS.new(['bin/rake']))
        assert_equal 'bundle exec rake test TEST=<test>', Rake.command(all: false, file_system: FakeFS.new([]))

        # take into account gem repository which doesn't have a bin file
        assert_equal 'bundle exec rake test TEST=<test>', Rake.command(all: false)
        assert_equal 'bundle exec rake test', Rake.command(all: true)
      end
    end

    class RubyTest < MiniTest::Test
      def test_command_without_gemfile
        assert_equal 'ruby <test>', Ruby.command(all: true, file_system: FakeFS.new(['bin/ruby']))
        assert_equal 'ruby <test>', Ruby.command(all: true, file_system: FakeFS.new([]))
        assert_equal 'ruby <test>', Ruby.command(all: false, file_system: FakeFS.new(['bin/ruby']))
        assert_equal 'ruby <test>', Ruby.command(all: false, file_system: FakeFS.new([]))
      end

      def test_command_with_gemfile
        fs_files = ['Gemfile.lock']

        assert_equal 'bundle exec ruby <test>', Ruby.command(all: true, file_system: FakeFS.new(['Gemfile.lock', 'bin/ruby']))
        assert_equal 'bundle exec ruby <test>', Ruby.command(all: true, file_system: FakeFS.new(['Gemfile.lock']))
        assert_equal 'bundle exec ruby <test>', Ruby.command(all: false, file_system: FakeFS.new(['Gemfile.lock', 'bin/ruby']))
        assert_equal 'bundle exec ruby <test>', Ruby.command(all: false, file_system: FakeFS.new(['Gemfile.lock']))
      end
    end
  end
end