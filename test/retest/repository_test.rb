require 'test_helper'

module Retest
  class RepositoryTest < MiniTest::Test
    def setup
      @subject = Repository.new
    end

    def test_default_files
      assert_equal Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*'), @subject.files
    end

    def test_find_tests
      @subject.files = %w(
        core/app/controllers/admin/billing_agent_customers_controller.rb
        spec/models/billing_agent_customer_spec.rb
        core/spec/models/billing_agent_customer_spec.rb
        core/spec/controllers/admin/billing_agent_customers_controller_spec.rb
      )

      assert_equal %w(
          spec/models/billing_agent_customer_spec.rb
          core/spec/models/billing_agent_customer_spec.rb
        ),
        @subject.find_tests('core/models/billing_agent_customer.rb')
    end

    def test_find_test
      @subject.files = %w(
        test/songs/99bottles.txt
        test/bottles_test.rb
        program.rb
        README.md
        lib/bottles.rb
        Gemfile
        Gemfile.lock
      )

      assert_equal 'test/bottles_test.rb',
        @subject.find_test('99bottles_ruby/lib/bottles.rb')
    end

    def test_find_test_with_similar_filenames
      @subject.files = %w(
        core/app/controllers/admin/billing_agent_customers_controller.rb
        spec/models/billing_agent_customer_spec.rb
        core/spec/models/billing_agent_customer_spec.rb
        core/spec/controllers/admin/billing_agent_customers_controller_spec.rb
      )

      assert_equal 'spec/models/billing_agent_customer_spec.rb',
        @subject.find_test('app/models/billing_agent_customer.rb')

      assert_equal 'core/spec/models/billing_agent_customer_spec.rb',
        @subject.find_test('core/models/billing_agent_customer.rb')
    end
  end
end