module Retest
  module Runners
    module RunnerInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
        assert_respond_to @subject, :run_all_tests
        assert_respond_to @subject, :sync
      end

      def test_run_accepts_the_right_parameter
        _, _ = capture_subprocess_io { @subject.run 'some-path.rb', repository: Repository.new }
      end

      def test_equal
        runner1 = @subject.class.new('hello')
        runner2 = @subject.class.new('hello')
        runner3 = @subject.class.new('world')

        assert_equal runner1, runner2
        refute_equal runner1, runner3
      end
    end
  end
end
