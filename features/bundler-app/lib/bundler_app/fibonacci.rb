# fibonacci.rb
class Fibonacci
  def self.calculate(n)
    raise ArgumentError, "Input must be a non-negative integer." unless n.is_a?(Integer) && n >= 0
    return n if n <= 1

    a, b = 0, 1
    (n - 1).times { a, b = b, a + b }
    b
  end
end