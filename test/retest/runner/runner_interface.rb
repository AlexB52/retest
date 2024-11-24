module Retest
  class Runner
    module RunnerInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
        assert_respond_to @subject, :sync
      end

      def test_run_accepts_the_right_parameter
        _, _ = capture_subprocess_io { @subject.run changed_files: ['some-path.rb'], test_files: ['some-test-path.rb'] }
      end
    end
  end
end
