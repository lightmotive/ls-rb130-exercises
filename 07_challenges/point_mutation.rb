# frozen_string_literal: true

# The differences between two DNA strands (comparing letters) is called the
# Hamming distance.
#
# Rules:
# - Count differences between the shorter of two strands when lengths differ.

# Data structure:
# Convert each string (strand) to a separate arrays of chars for comparison.

# Basic algorithm:
# - Iterate through the shortest string's indices.
#   - Count differences across strings, comparing each letter at each index.

class DNA
  attr_reader :strand

  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    shortest_length = strand.size < other_strand.size ? strand.size : other_strand.size
    distance = 0
    shortest_length.times do |idx|
      distance += 1 unless strand[idx] == other_strand[idx]
    end
    distance
  end
end
