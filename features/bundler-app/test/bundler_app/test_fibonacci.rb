# frozen_string_literal: true

require 'test_helper'

module BundlerApp
  class FibonacciTest < Minitest::Test
    def test_fibonacci_zero
      assert_equal 0, Fibonacci.calculate(0)
    end

    def test_fibonacci_one
      assert_equal 1, Fibonacci.calculate(1)
    end

    def test_fibonacci_two
      assert_equal 1, Fibonacci.calculate(2)
    end

    def test_fibonacci_five
      assert_equal 5, Fibonacci.calculate(5)
    end

    def test_fibonacci_ten
      assert_equal 55, Fibonacci.calculate(10)
    end

    def test_large_fibonacci
      assert_equal 6765, Fibonacci.calculate(20) # Example large Fibonacci number
    end

    def test_invalid_input_negative
      assert_raises(ArgumentError) { Fibonacci.calculate(-1) }
    end

    def test_invalid_input_non_integer
      assert_raises(ArgumentError) { Fibonacci.calculate(2.5) }
      assert_raises(ArgumentError) { Fibonacci.calculate("five") }
    end
  end
end