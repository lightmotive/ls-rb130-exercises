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
