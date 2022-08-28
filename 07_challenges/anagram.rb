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
  attr_reader :subject

  def initialize(subject)
    @subject = subject
    @subject_for_dup_cmp = standardize_for_dup_cmp(subject)
    @subject_for_anagram_cmp = standardize_for_anagram_cmp(subject)
  end

  def match(words_or_phrases)
    words_or_phrases.each_with_object([]) do |candidate, anagrams|
      next if @subject_for_dup_cmp == standardize_for_dup_cmp(candidate)

      anagrams << candidate if subject_for_anagram_cmp == standardize_for_anagram_cmp(candidate)
    end
  end

  private

  attr_reader :subject_for_dup_cmp, :subject_for_anagram_cmp

  def standardize_for_dup_cmp(string)
    string.downcase
  end

  def standardize_for_anagram_cmp(string)
    string.gsub(/\s+/, '').downcase.chars.sort.join
  end
end
