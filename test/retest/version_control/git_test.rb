require 'test_helper'
require_relative 'shared_interface'

module Retest
  class VersionControl::GitTest < Minitest::Test
    include VersionControl::SharedInterface

    def setup
      @subject = VersionControl::Git
    end

    def test_diff_names
      assert_respond_to @subject, :diff_files
    end
  end
end