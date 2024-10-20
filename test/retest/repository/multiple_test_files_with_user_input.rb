require 'test_helper'

module Retest
  class MultipleTestFilesWithUserInputTest < Minitest::Test
    def setup
      files = %w(
        core/app/controllers/admin/billing_agent_customers_controller.rb
        spec/models/billing_agent_customer_spec.rb
        core/spec/models/billing_agent_customer_spec.rb
        core/spec/controllers/admin/billing_agent_customers_controller_spec.rb
      )

      @subject = Repository.new(files: files)
    end

    def test_find_test_user_input_question
      @subject.prompt = Prompt.new(input: StringIO.new("1\n"), output: StringIO.new)

      @subject.find_test('app/models/billing_agent_customer.rb')

      assert_equal <<~EXPECTED.chomp, @subject.prompt.read_output
        We found few tests matching: app/models/billing_agent_customer.rb

        [0] - spec/models/billing_agent_customer_spec.rb
        [1] - core/spec/models/billing_agent_customer_spec.rb
        [2] - none

        Which file do you want to use?
        Enter the file number now:
        >\s
      EXPECTED
    end

    FakePrompt = Struct.new(:input_choice, keyword_init: true) do
      def options(files)
        result = {}
        files.each { |file| result[file] = file }
        result['none'] = nil
        result
      end

      def ask_which_test_to_use(path, files)
        options(files).values[input_choice]
      end
    end

    def test_find_test_user_select_0
      @subject.prompt = FakePrompt.new(input_choice: 0)
      assert_equal 'spec/models/billing_agent_customer_spec.rb', @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_1
      @subject.prompt = FakePrompt.new(input_choice: 1)
      assert_equal 'core/spec/models/billing_agent_customer_spec.rb', @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_2
      # none exist
      @subject.prompt = FakePrompt.new(input_choice: 2)
      assert_nil @subject.find_test('app/models/billing_agent_customer.rb')
    end

    def test_find_test_user_select_cache_answer
      expected = 'spec/models/billing_agent_customer_spec.rb'

      @subject.prompt = FakePrompt.new(input_choice: 0)
      assert_equal expected, @subject.find_test('app/models/billing_agent_customer.rb')

      @subject.prompt = FakePrompt.new(input_choice: 2)
      assert_equal expected, @subject.find_test('app/models/billing_agent_customer.rb')
    end
  end
end