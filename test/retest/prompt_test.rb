require 'test_helper'

module Retest
  class PromptTest < MiniTest::Test

    def setup
      @subject = Prompt.new(output: StringIO.new)
    end

    def test_ask_which_test_to_use
      files = %w(
        test/models/taxation/holdings_test.rb
        test/models/schedule/holdings_test.rb
        test/models/holdings_test.rb
        test/models/performance/holdings_test.rb
        test/lib/csv_report/holdings_test.rb
      )

      @subject.input = StringIO.new("1\n")

      result = @subject.ask_which_test_to_use("app/models/valuation/holdings.rb", files)

      assert_equal "test/models/schedule/holdings_test.rb", result
      assert_equal <<~EXPECTED, @subject.read_output
        We found few tests matching: app/models/valuation/holdings.rb

        [0] - test/models/taxation/holdings_test.rb
        [1] - test/models/schedule/holdings_test.rb
        [2] - test/models/holdings_test.rb
        [3] - test/models/performance/holdings_test.rb
        [4] - test/lib/csv_report/holdings_test.rb

        Which file do you want to use?
        Enter the file number now:
      EXPECTED
    end

    def test_read_output
      @subject.output.puts "hello world\n"

      assert_equal "hello world\n", @subject.read_output
    end

    def test_puts
      out, _ = capture_subprocess_io { Prompt.puts "hello world\n" }
      assert_equal "hello world\n", out
    end
  end
end
