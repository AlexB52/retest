require 'test_helper'
require_relative 'runner_interface'
require_relative 'observable_runner'

module Retest
  module Runners
    class VariableRunnerInterfaceTests < MiniTest::Test
      def setup
        @repository = Repository.new files: ['file_path_test.rb']
        @subject    = VariableRunner.new("echo 'touch <changed> & <test>'")
      end

      include RunnerInterfaceTest
      include OversableRunnerTests

      private

      def observable_act(subject)
        subject.run(
          'file_path.rb',
          repository: Repository.new(files: ['file_path_test.rb'])
        )
      end
    end

    class VariableRunnerTest < MiniTest::Test
      def setup
        @repository = Repository.new files: ['file_path_test.rb']
        @subject    = VariableRunner.new("echo 'touch <changed> & <test>'", stdout: StringIO.new)
      end

      def output
        @subject.stdout.string
      end

      def test_files_selected_ouptut
        _, _ = capture_subprocess_io { @subject.run('file_path.rb', repository: @repository) }

        assert_equal(<<~EXPECTED, output)
          Files Selected:
            - changed: file_path.rb
            - test: file_path_test.rb

        EXPECTED
      end

      def test_run_with_no_match
        _, _ = capture_subprocess_io { @subject.run('another_file_path.rb', repository: @repository) }

        assert_equal(<<~EXPECTED, output)
          404 - Test File Not Found
          Retest could not find a matching test file to run.
        EXPECTED
      end

      def test_run_with_a_file_found
        out, _ = capture_subprocess_io { @subject.run('file_path.rb', repository: @repository) }

        assert_match "touch file_path.rb & file_path_test.rb", out
      end

      def test_returns_last_command
        out, _ = capture_subprocess_io { @subject.run('file_path.rb', repository: @repository) }

        assert_match "touch file_path.rb & file_path_test.rb", out

        out, _ = capture_subprocess_io { @subject.run('another_file_path.rb', repository: @repository) }

        assert_match "touch another_file_path.rb & file_path_test.rb", out
      end

      def test_sync_files
        @subject.cached_test_file = 'file_path_test.rb'

        @subject.sync(added: [], removed:['something.rb'])
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.sync(added: nil, removed:'something.rb')
        assert_equal 'file_path_test.rb', @subject.cached_test_file

        @subject.sync(added: ['a.rb'], removed:['file_path_test.rb'])
        assert_nil @subject.cached_test_file

        @subject.cached_test_file = 'file_path_test.rb'
        @subject.sync(added: 'a.rb', removed:'file_path_test.rb')
        assert_nil @subject.cached_test_file
      end

      def test_run_all_tests
        assert_raises(NotSupportedError) { @subject.run_all_tests('file_path.rb file_path_two.rb') }
      end
    end
  end
end