module Retest
  module Sounds
    module SoundsInterfaceTests
      def test_interface
        assert_respond_to @subject, :play
      end
    end
  end
end