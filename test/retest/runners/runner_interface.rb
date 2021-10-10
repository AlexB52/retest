module Retest
  module Runners
    module RunnerInterfaceTest
      def test_behaviour
        assert_respond_to @subject, :==
        assert_respond_to @subject, :run
        assert_respond_to @subject, :remove
        assert_respond_to @subject, :update
        assert_respond_to @subject, :matching?
        assert_respond_to @subject, :unmatching?
      end
    end
  end
end
