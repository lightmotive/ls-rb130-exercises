# frozen_string_literal: true

# * Understand *
# Write a program that, given a natural number and a set of 1 or more other
# numbers, can find the sum of all the multiples of the numbers in the set that
# are less than the first number. If the set of numbers is not given,
# use a default set of 3 and 5.

class SumOfMultiples
  # * Tests/examples *
  # For instance, if we list all the natural numbers up to, but not including, 20
  # that are multiples of either 3 or 5, we get 3, 5, 6, 9, 10, 12, 15, and 18.
  # The sum of these multiples is 78.

  # * Data structures *

  # * Algorithm *

  attr_reader :multiples_of_numbers

  def initialize(*multiples_of_numbers)
    @multiples_of_numbers = multiples_of_numbers.empty? ? [3, 5] : multiples_of_numbers
  end

  def to(max_excluded)
    # Find the sum of all multiples of `multiples_of_numbers` up to, but excluding, `max_excluded`:
    # Algorithm...
  end
end
