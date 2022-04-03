require 'test_helper'
require_relative './sounds_interface'

module Retest
  module Sounds
    class MuteTests < MiniTest::Test
      include SoundsInterfaceTests

      def setup
        @subject = Mute.new
      end

    end
  end
end
