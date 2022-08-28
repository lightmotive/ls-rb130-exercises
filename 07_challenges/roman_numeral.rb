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
# - Iterate through NUMERALS as |numeral, unit| (largest to smallest):
#   - Divide remainder by unit to get quotient and remainder.
#     - quotient indicates number of numerals
#       - If quotient <= 3, append (numeral * quotient) to numerals.
#       - If quotient == 4, append "#{numeral}#{previous_numeral}".
#         - quotient should never exceed 4.
