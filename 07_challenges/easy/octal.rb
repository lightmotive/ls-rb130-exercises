# frozen_string_literal: true

# * Understand *
# IO:
# Class Octal::new parameters: string that represents an octal value
# Octal#to_decimal output: decimal value; errors indicated as 0

# Rules:
# - Invalid strings should return 0, including anything with letters
# - Leading 0s are allowed and should be truncated.
# - Allowed digits: 0-7

# * Examples *
# - See test/octal_test.rb.

# * Data structure *
# - The input is a string, which we can split into an array of characters to
#   evaluate one digit at a time.

# * Algorithm *
# Given an `octal_string` input:
# - Validate string: `return 0 if octal_string.count(^0-7) > 0`--use helper).
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

class Octal
  attr_reader :value_string

  def initialize(octal_string)
    @value_string = octal_string.gsub(/^0+/, '')
  end

  def to_decimal
    return 0 unless valid?

    value_string.reverse.each_char.with_index.reduce(0) do |sum, (char, exponent)|
      sum + char.to_i * (8**exponent)
    end
  end

  private

  def valid?
    !value_string.empty? && value_string.count('^0-7').zero?
  end
end
