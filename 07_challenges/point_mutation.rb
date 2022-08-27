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
# - Check strand length.
#   - If different, iterate through the shorter array with index.
# - Count differences across arrays, comparing each letter at each index.
