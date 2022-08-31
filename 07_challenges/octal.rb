# frozen_string_literal: true

# * Understand *
# IO:
# Class Octal::new parameters: string that represents an octal value
# Octal#to_decimal output: decimal value; errors indicated as 0

# Rules:
# - Invalid strings should return 0, including anything with letters
# - Leading 0s are allowed and should be truncated.

# * Examples *
# - See test/octal_test.rb.

# * Data structure *
# - The input is a string, which we can split into an array of characters to
#   evaluate one digit at a time.

# * Algorithm *
# Given an `octal_string` input:
# - Validate string: `return 0 if octal_string.count(^0-9) > 0`--use helper).
# - Drop leading zeros.
# - Reverse string, then enumerate through remaining chars with index.
#   - Convert the char to an integer.
#   - Multiply the char by 8^idx.
#   - Sum all values (reduce).
#
# Example:
# "17" => 15
# "71"
# 7 * 8^0 = 7
# 1 * 8^1 = 8
# 7 + 8 = 15
# Valid!
