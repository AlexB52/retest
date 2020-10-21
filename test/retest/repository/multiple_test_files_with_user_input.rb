require 'test_helper'

module Retest
  class MultipleTestFilesWithUserInputTest < MiniTest::Test
    def setup
      files = %w(
        core/app/controllers/admin/billing_agent_customers_controller.rb
        spec/models/billing_agent_customer_spec.rb
        core/spec/models/billing_agent_customer_spec.rb
        core/spec/controllers/admin/billing_agent_customers_controller_spec.rb
      )

      @subject = Repository.new files: files, output_stream: StringIO.new
    end

    def test_find_test_user_input_question
      @subject.input_stream = StringIO.new("1\n")
      @subject.output_stream = STDOUT

      out, _ = capture_subprocess_io { @subject.find_test('app/models/billing_agent_customer.rb') }

      assert_match <<~EXPECTED, out
        We found few tests matching:
        [0] - spec/models/billing_agent_customer_spec.rb
        [1] - core/spec/models/billing_agent_customer_spec.rb

        Which file do you want to use?
        Enter the file number now:
      EXPECTED
    end

    def test_find_test_user_select_0
      @subject.input_stream = StringIO.new("0\n")

      assert_equal 'spec/models/billing_agent_customer_spec.rb', @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_1
      @subject.input_stream = StringIO.new("1\n")

      assert_equal 'core/spec/models/billing_agent_customer_spec.rb', @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_2
      @subject.input_stream = StringIO.new("2\n")

      assert_nil @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_cache_answer
      @subject.input_stream = StringIO.new("0\n")
      expected = 'spec/models/billing_agent_customer_spec.rb'

      assert_equal expected, @subject.find_test('app/models/billing_agent_customer.rb')

      @subject.input_stream = StringIO.new("2\n") # A wrong input

      assert_equal expected, @subject.find_test('app/models/billing_agent_customer.rb')
    end
  end
end