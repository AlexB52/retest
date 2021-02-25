require 'test_helper'

module Retest
  class RunnerTest < MiniTest::Test
    module RunnerInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
        assert_respond_to @subject, :remove
      end
    end

    def test_self_for
      assert_equal Runner::HardcodedRunner.new('bundle exec rake test'), Runner.for('bundle exec rake test')
      assert_equal Runner::VariableRunner.new('bundle exec rake test TEST=<test>'), Runner.for('bundle exec rake test TEST=<test>')
    end

    class HardcodedRunner < MiniTest::Test
      include RunnerInterfaceTest

      def setup
        @subject = Runner::HardcodedRunner.new("echo 'hello'")
      end

      def test_run
        out, _ = capture_subprocess_io { @subject.run('file_path.rb') }

        assert_match "hello", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "hello", out
      end
    end

    class VariableRunnerTest < MiniTest::Test
      include RunnerInterfaceTest

      def setup
        @repository = Repository.new

        @subject = Runner::VariableRunner.new("echo 'touch <test>'")
      end

      def test_run_with_no_file_found
        out, _ = capture_subprocess_io { @subject.run }

        assert_equal <<~EXPECTED, out
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_purge_files
        @subject.cached_test_file = 'file_path_test.rb'

        @subject.remove(['something.rb'])
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.remove('something.rb')
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.remove(['file_path_test.rb'])
        assert_nil @subject.cached_test_file

        @subject.cached_test_file = 'file_path_test.rb'
        @subject.remove('file_path_test.rb')
        assert_nil @subject.cached_test_file

      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run('file_path_test.rb') }

        assert_match "touch file_path_test.rb", out
      end

      def test_returns_last_command
        out, _ = capture_subprocess_io { @subject.run('file_path_test.rb') }

        assert_match "touch file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run }

        assert_match "touch file_path_test.rb", out
      end
    end
  end
end