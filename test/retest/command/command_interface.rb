module Retest
  class Command
    module CommandInterface
      def test_interface
        assert_respond_to @subject, :format_batch
        assert_respond_to @subject, :to_s
      end
    end
  end
end
