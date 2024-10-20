require 'test_helper'

module FileSystemShared
  def test_interface
    assert_respond_to @subject, :exist?
  end
end

module Retest
  class FileSystemTest < Minitest::Test
    include FileSystemShared

    def setup
      @subject = FileSystem
    end

    def test_exists?
      assert @subject.exist? 'test/retest/file_system_test.rb'
    end
  end

  class FakeFSTest < Minitest::Test
    include FileSystemShared

    def setup
      @subject = FakeFS.new []
    end
  end
end