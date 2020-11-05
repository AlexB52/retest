require 'test_helper'

module Retest
  module ToolInterface
    def match_tool_interface?(tool)
      assert_respond_to tool, :installed?
      assert_respond_to tool, :files
      assert_respond_to tool, :name
      assert_respond_to tool, :to_s
    end
  end

  FakeTool = Struct.new(:files) do
    def name; 'fake' end
    alias :to_s :name
  end

  class ListenOptionsTest < MiniTest::Test
    include ToolInterface

    class InstalledTool   < FakeTool; def installed?; true  end end
    class UninstalledTool < FakeTool; def installed?; false end end

    def test_fake_tools
      match_tool_interface? UninstalledTool.new
      match_tool_interface? InstalledTool.new
    end

    def test_to_h_with_installed_tool
      files = "file.rb\nfile.txt"

      expected_options = {only: /file.rb|file.txt/, relative: true}
      options = ListenOptions.to_h InstalledTool.new(files)

      assert_equal expected_options, options
    end

    def test_to_h_with_uninstalled_tool
      expected_options = {ignore: ListenOptions::IGNORE_REGEX, relative: true}
      options = ListenOptions.to_h UninstalledTool.new

      assert_equal expected_options, options
    end
  end

  class ToolInterfaceTest < MiniTest::Test
    include ToolInterface

    def test_git_tool
      match_tool_interface? GitTool.new
    end
  end
end