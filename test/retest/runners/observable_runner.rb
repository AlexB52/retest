module Retest
  module Runners
    module OversableRunnerTests
      def test_publishes_event_after_running_command
        observer = MiniTest::Mock.new
        observer.expect :update, true, [:tests_pass]
        observer.expect :hash, 1111

        @subject.add_observer(observer)

        capture_subprocess_io { observable_act(@subject) }

        observer.verify
      end

      def observable_act(subject)
        raise NotImplementedError.new("#observable_act is not implemented")
      end
    end

    module ObserverInterfaceTests
      def test_observer_interface
        assert_respond_to @subject, :update
      end
    end
  end
end
