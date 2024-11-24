module Retest
  class Command
    module CommandInterface
      def test_interface
        assert_respond_to @subject, :format_batch
        assert_respond_to @subject, :to_s
      end

      def test_initializatioin
        @subject.class.new
        @subject.class.new(all: '', file_system: '', command: '')
      end
    end
  end
end
