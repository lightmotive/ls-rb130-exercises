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
# Given an `integer`:
# - Initialize `numerals = ''`
# - remainder = integer
# - Enumerate through NUMERALS as |numeral, unit| (largest to smallest):
#   - Skip numeral if remainder < unit.
#   - Divide remainder by unit to get quotient and remainder.
#     - quotient indicates number of numerals
#       - If quotient <= 3, append (numeral * quotient) to numerals.
#       - Else If quotient > 4, append "#{numeral}#{previous_numeral}".
#         - quotient should never exceed 4.
#       - next_remainder = remainder((unit - remainder) / next_unit)
#         - If next_remainder > 3:
#           - Convert remainder to...
# ...this is too complicated. Need an algorithm that looks at each digit...
# Test algorithm:
# remainder = 149
# Enumerate...
#   ***...skip 1000 and 500...***
#   *** C, 100 ***
#   149 / 100 = 1r49
#   numerals += C
#   remainder = 49
#   *** skip L, 50 ***
#   *** X, 10 ***
#   49 / 10 = 4r9
#   numerals += XL => CXL
#   remainder = 9
#   *** V, 5 ***
#   9 / 5 = 1r4
#   numerals += V => CXLV
#   remainder = 4
#   *** I, 1 ***
#   4 / 1 = 4r0
#   Need to replace previous letter with
