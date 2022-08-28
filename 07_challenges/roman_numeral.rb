# frozen_string_literal: true

# Convert integers to Roman numerals.
# Mental model: Roman numerals use a system of addition and subtraction...
# - When there are 3 or fewer units to be added, they are written at the end.
# - When there are more than 3 additions, one subtracts from the next unit.
#
# The units:
# I: 1
# V: 5
# X: 10
# L: 50
# C: 100
# D: 500
# M: 1000
#   For this problem, we'll ignore the line over numerals, which indicates the
#   numeral * 1000

# Data structure:
# - Store [numeral_string, unit_integer] pairs in an array to support iteration
#   and index-based adjacent lookups.

# Algorithm:
# Constant:
# NUMERALS = [
#   ['M', 1000],
#   ['D', 500],
#   ['C', 100],
#   ['L', 50],
#   ['X', 10],
#   ['V', 5],
#   ['I', 1]
# ]
# ** Previous algorithm deleted. **

require 'pry'

class RomanNumeral
  NUMERALS = { 'M' => 1000, 'CM' => 900,
               'D' => 500, 'CD' => 400,
               'C' => 100, 'XC' => 90,
               'L' => 50, 'XL' => 40,
               'X' => 10, 'IX' => 9,
               'V' => 5, 'IV' => 4,
               'I' => 1 }.freeze

  attr_reader :integer

  def initialize(integer)
    @integer = integer
  end

  def to_roman
    remaining = integer

    NUMERALS.each_with_object(String.new) do |(numeral, numeral_unit), numerals|
      next if remaining < numeral_unit

      while remaining >= numeral_unit
        numeral_count, remaining = remaining.divmod(numeral_unit)
        numerals << numeral.to_s * numeral_count
      end
    end
  end
end
