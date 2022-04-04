require_relative '../runners/observable_runner'

module Retest
  module Sounds
    module SoundsInterfaceTests
      include Runners::ObserverInterfaceTests

      def test_interface
        assert_respond_to @subject, :play
      end
    end
  end
end