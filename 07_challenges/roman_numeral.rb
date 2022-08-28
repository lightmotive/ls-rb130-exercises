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
# Given an `integer`:
# - Initialize `numerals = ''`
# - integer_string = integer.to_s.rjust(4, "0")
# 0..3 { |pos_idx|
#   pos_value = integer_string[pos_idx].to_i
#   - skip if pos_value.zero?
#   pos_value *= POSITION_MULTIPLIER[pos_idx]
#   - numerals += roman_numerals(pos_value)
# }
#
# private
#
# def roman_numerals(number)
#   numerals = ''
#   Iterate through (0...NUMERALS.size) as |numeral_idx|:
#     numeral, unit = NUMERALS[numeral_idx]
#     previous_numeral, previous_unit = NUMERALS[numeral_idx - 1] unless numeral_idx.zero?
#     - Skip if number < unit
#
#     if number == (previous_unit - unit)
#       numerals += "#{numeral}#{previous_numeral}"
#     else
#       while number >= unit
#         numerals += numeral
#         number -= unit
# end
