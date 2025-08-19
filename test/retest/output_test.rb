require 'test_helper'

module Retest
  class TestForceBatchFailures < Minitest::Test
    def test_without_stdout
      assert_equal <<~OUTPUT, Output.force_batch_failures(%w[hello.rb test/unknown.rb lib.rb Gemfile])

        Retest could not find matching tests for these inputs:
          - hello.rb
          - test/unknown.rb
          - lib.rb
          - Gemfile

      OUTPUT
    end

    def test_with_empty_paths
      assert_nil Output.force_batch_failures([])
      assert_nil Output.force_batch_failures(nil)
    end

    def test_with_stdout
      stdout = StringIO.new
      Output.force_batch_failures(%w[hello.rb test/unknown.rb lib.rb Gemfile], out: stdout)

      assert_equal <<~OUTPUT, stdout.tap(&:rewind).read

        Retest could not find matching tests for these inputs:
          - hello.rb
          - test/unknown.rb
          - lib.rb
          - Gemfile

      OUTPUT
    end
  end
end