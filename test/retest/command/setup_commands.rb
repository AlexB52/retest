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
        assert_equal 'bundle exec rspec', Rspec.command(all: true)
      end
    end

    class RailsTest < MiniTest::Test
      def test_command
        assert_equal 'bin/rails test',                Rails.command(all: true, bin_file: true)
        assert_equal 'bundle exec rails test',        Rails.command(all: true, bin_file: false)
        assert_equal 'bin/rails test <test>',         Rails.command(all: false, bin_file: true)
        assert_equal 'bundle exec rails test <test>', Rails.command(all: false, bin_file: false)

        # take into account gem repository which doesn't have a bin/rspec file
        assert_equal 'bundle exec rails test <test>', Rails.command(all: false)
        assert_equal 'bundle exec rails test', Rails.command(all: true)
      end
    end

    class RakeTest < MiniTest::Test
      def test_command
        assert_equal 'bin/rake test',                     Rake.command(all: true, bin_file: true)
        assert_equal 'bundle exec rake test',             Rake.command(all: true, bin_file: false)
        assert_equal 'bin/rake test TEST=<test>',         Rake.command(all: false, bin_file: true)
        assert_equal 'bundle exec rake test TEST=<test>', Rake.command(all: false, bin_file: false)

        # take into account gem repository which doesn't have a bin/rspec file
        assert_equal 'bundle exec rake test TEST=<test>', Rake.command(all: false)
        assert_equal 'bundle exec rake test', Rake.command(all: true)
      end
    end
  end
end