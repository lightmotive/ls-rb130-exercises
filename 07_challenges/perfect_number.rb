# frozen_string_literal: true

# * Problem domain *
# - Aliquot sum: the sum of positive divisors of a number, excluding the number itself.
# - Perfect numbers: Aliquot sum == original number
# - Abundant numbers: Aliquot sum > original number
# - Deficient numbers: Aliquot sum < original number

# * Rules *
# Number must be a positive integer (natural number).

# * Data structures *
# - Store positive divisors for a number in an array.
# - class PerfectNumber has:
#   - singleton method: classify(number) => String { 'perfect', 'abundant', or 'deficient' }

# * Algorithm *
# Given `number`:
# 1. Determine positive divisors excluding number, store in array (helper method)
# 2. Compare positive divisors sum with number to determine 'perfect', 'abundant', or 'deficient'

class PerfectNumber
  attr_reader :number

  SUM_TO_NUM_CLASSIFICATIONS = { -1 => 'deficient', 0 => 'perfect', 1 => 'abundant' }.freeze

  def initialize(number)
    raise ArgumentError, 'Number must be a positive integer.' unless number.instance_of?(Integer) && number.positive?

    @number = number
  end

  def classify
    SUM_TO_NUM_CLASSIFICATIONS[aliquot_divisors.sum <=> number]
  end

  def self.classify(number)
    new(number).classify
  end

  private

  def aliquot_divisors
    (number - 1).downto(1).with_object([]) do |n, divisors|
      divisors << n if (number % n).zero?
    end
  end
end
