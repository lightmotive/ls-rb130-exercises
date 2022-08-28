# frozen_string_literal: true

# The differences between two DNA strands (comparing letters) is called the
# Hamming distance.
#
# Rules:
# - Count differences between the shorter of two strands when lengths differ.

# Data structure:
# Convert each string (strand) to a separate arrays of chars for comparison.

# Basic algorithm:
# - Convert each strand to an array of chars.
# - Iterate through the shortest array with index.
#   - Count differences across arrays, comparing each letter at each index.

class DNA
  attr_reader :strand

  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    first_chars = strand.chars
    second_chars = other_strand.chars
    first_chars, second_chars = [first_chars, second_chars].minmax_by(&:size) if first_chars.size != second_chars.size

    first_chars.each_with_index.reduce(0) do |distance, (char, idx)|
      distance + (char == second_chars[idx] ? 0 : 1)
    end
  end
end
