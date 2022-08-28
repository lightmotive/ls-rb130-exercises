# frozen_string_literal: true

# The problem
# Input: string, array of strings (candidates: are they anagrams of `string`?)
# Output: array of strings that are anagrams of `string`
#
# Anagram rules:
# - They are words or phrases that rearrange letters of other words or phrases.
# - The rearrangements use each letter exactly once.
# - Ignore spaces in both the input and when checking the output.
# - Ignore identical words.
# - Anagrams are case-insensitive.

# Examples, test cases
# The provided test cases prompted some additional rules above.

# Data structures
# - class: Anagram (shell defined)
# - Candidates are provided as arrays.
# - Compare standardized strings.

# Algorithm:
# Class and basic iteration written first, then fleshed out.

class Anagram
  attr_reader :string

  def initialize(string)
    @string = string
    @string_for_comparison = string_for_comparison(@string)
  end

  def match(words_or_phrases)
    anagrams = []
    # - They are words or phrases that rearrange letters of other words or phrases.

    words_or_phrases.each do |candidate|
      # - Ignore identical words.

      candidate_for_comparison = string_for_comparison(candidate)
      # - The rearrangements use each letter exactly once.
    end

    anagrams
  end

  private

  attr_reader :string_for_comparison

  def string_for_comparison(string)
    # - Anagrams are case-insensitive.
    # - Ignore spaces in both the input and when checking the output.
  end
end
