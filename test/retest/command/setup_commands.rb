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
  end
end