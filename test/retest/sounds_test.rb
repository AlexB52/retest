require 'test_helper'

module Retest
  class SoundsTest < MiniTest::Test
    def test_sounds_for
      assert_instance_of Sounds::MacOS, Sounds.for(Options.new(['--notify']))
      assert_instance_of Sounds::Mute,  Sounds.for(Options.new([]))
    end
  end
end