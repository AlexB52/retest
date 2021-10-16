module Retest
  module Runners
    module RunnerInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
        assert_respond_to @subject, :sync
        assert_respond_to @subject, :matching?
        assert_respond_to @subject, :unmatching?
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
