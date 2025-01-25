module Retest
  class Command
    module CommandInterface
      def test_interface
        assert_respond_to @subject, :format_batch
        assert_respond_to @subject, :to_s
        assert_respond_to @subject, :switch_to
        assert_respond_to @subject, :has_test?
        assert_respond_to @subject, :has_changed?
        assert_respond_to @subject, :hardcoded?

        # internals
        assert_respond_to @subject, :command
        assert_respond_to @subject, :file_system
        assert_respond_to @subject, :hash
        assert_respond_to @subject, :eql?
      end

      def test_initializatioin
        @subject.class.new
        @subject.class.new(all: '', file_system: '', command: '')
      end
    end
  end
end
