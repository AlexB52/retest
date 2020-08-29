require "test_helper"

class RetestTest < Minitest::Test
  include Retest

  def test_that_it_has_a_version_number
    refute_nil ::Retest::VERSION
  end

  def test_find_test
    files = %w(
      test/songs/99bottles.txt
      test/bottles_test.rb
      program.rb
      README.md
      lib/bottles.rb
      Gemfile
      Gemfile.lock
    )

    assert_equal 'test/bottles_test.rb',
      find_test('99bottles_ruby/lib/bottles.rb', files: files)
  end

  def test_find_test_with_similar_filenames
    files = %w(
      core/app/controllers/admin/billing_agent_customers_controller.rb
      spec/models/billing_agent_customer_spec.rb
      core/spec/models/billing_agent_customer_spec.rb
      core/spec/controllers/admin/billing_agent_customers_controller_spec.rb
    )

    assert_equal 'spec/models/billing_agent_customer_spec.rb',
      find_test('app/models/billing_agent_customer.rb', files: files)

    assert_equal 'core/spec/models/billing_agent_customer_spec.rb',
      find_test('core/models/billing_agent_customer.rb', files: files)
  end
end
