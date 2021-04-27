module Retest
  class Command
    class RspecTest < MiniTest::Test
      def test_command
        assert_equal 'bin/rspec',                Rspec.command(all: true, bin_file: true)
        assert_equal 'bundle exec rspec',        Rspec.command(all: true, bin_file: false)
        assert_equal 'bin/rspec <test>',         Rspec.command(all: false, bin_file: true)
        assert_equal 'bundle exec rspec <test>', Rspec.command(all: false, bin_file: false)

        # take into account gem repository which doesn't have a bin/rspec file
        assert_equal 'bundle exec rspec <test>', Rspec.command(all: false)
      end
    end
  end
end