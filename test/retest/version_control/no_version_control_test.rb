require 'test_helper'
require_relative 'shared_interface'

module Retest
  class VersionControl::NoVersionControlTest < Minitest::Test
    def setup
      @subject = VersionControl::NoVersionControl
    end

    include VersionControl::SharedInterface
  end
end