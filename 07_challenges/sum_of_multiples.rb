# frozen_string_literal: true

# * Understand *
# Write a program that, given a natural number and a set of 1 or more other
# numbers, can find the sum of all the multiples of the numbers in the set that
# are less than the first number.

class SumOfMultiples
  attr_reader :multiple_factors

  def initialize(*multiple_factors)
    @multiple_factors = multiple_factors.empty? ? [3, 5] : multiple_factors
  end

  def to(max_excluded)
    natural_number_multiples(max_excluded).sum
  end

  def self.to(max_excluded)
    new.to(max_excluded)
  end

  private

  def natural_number_multiples(max_excluded)
    (1...max_excluded).select(&method(:multiple?))
  end

  def multiple?(number)
    multiple_factors.any? { |factor| (number % factor).zero? }
  end
end
