module Retest
  class Command
    module CommandInterface
      def test_interface
        assert_respond_to @subject, :format_batch
        assert_respond_to @subject, :to_s
        assert_respond_to @subject, :has_test?
        assert_respond_to @subject, :has_changed?
        assert_respond_to @subject, :test_type?
        assert_respond_to @subject, :changed_type?
        assert_respond_to @subject, :variable_type?
        assert_respond_to @subject, :hardcoded_type?
      end

      def test_initializatioin
        @subject.class.new
        @subject.class.new(all: '', file_system: '', command: '')
      end
    end
  end
end
