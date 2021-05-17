require 'test_helper'

module Retest
  class FileSystemTest < MiniTest::Test
    def setup
      @subject = FileSystem
    end

    def test_exists?
      assert @subject.exist? 'test/retest/file_system_test.rb'
    end
  end
end