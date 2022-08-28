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
# POSITION_MULTIPLIER = [1000, 100, 10, 1]
# def to_roman
#   Given an `integer` during class init:
#   - Initialize `numerals = ''`
#   - integer_string = integer.to_s.rjust(4, "0")
#   0..3 { |pos_idx|
#     pos_value = integer_string[pos_idx].to_i
#     - skip if pos_value.zero?
#     pos_value *= POSITION_MULTIPLIER[pos_idx]
#     - numerals += roman_numerals(pos_value)
#   }
#   - Return numerals
# end
#
# private
#
# def roman_numerals(unit_number)
#   numerals = ''
#   Iterate through (0...NUMERALS.size) as |numeral_idx|:
#     numeral, unit = NUMERALS[numeral_idx]
#     previous_numeral, previous_unit = NUMERALS[numeral_idx - 1] unless numeral_idx.zero?
#     - Skip if unit_number < unit
#
#     if unit_number == (previous_unit - unit)
#       numerals += "#{numeral}#{previous_numeral}"
#     else
#       while unit_number >= unit
#         numerals += numeral
#         unit_number -= unit
#
#   return numerals
# end

require 'pry'

class RomanNumeral
  NUMERALS = { M: 1000, CM: 900,
               D: 500, CD: 400,
               C: 100, XC: 90,
               L: 50, XL: 40,
               X: 10, IX: 9,
               V: 5, IV: 4,
               I: 1 }.freeze
  POSITION_MULTIPLIER = [1000, 100, 10, 1].freeze

  attr_reader :integer

  def initialize(integer)
    @integer = integer
  end

  def to_roman
    numerals = ''

    integer_string = integer.to_s.rjust(4, '0')
    (0..3).each do |pos_idx|
      pos_value = integer_string[pos_idx].to_i
      next if pos_value.zero?

      unit_integer = pos_value * POSITION_MULTIPLIER[pos_idx]
      numerals += unit_roman_numerals(unit_integer)
    end

    numerals
  end

  private

  def unit_roman_numerals(unit_integer)
    unit_match = NUMERALS.key(unit_integer)
    return unit_match.to_s unless unit_match.nil?

    NUMERALS.each_with_object(String.new) do |(numeral, numeral_unit), numerals|
      next if unit_integer < numeral_unit

      while unit_integer >= numeral_unit
        numerals << numeral.to_s
        unit_integer -= numeral_unit
      end
    end
  end
end
