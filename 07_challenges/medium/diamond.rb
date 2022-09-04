# frozen_string_literal: true

# * Understand *
# - Within basic class structure below.

class Diamond
  def self.make_diamond(to_letter)
    # Rules:
    # - Ensure to_letter length is 1 && to_letter.ord >= 'A'.ord.
    # - Upcase to_letter.

    # * Examples *
    # - See test/diamond_test.rb

    # * Data structure *
    # - Since the halves on either side of the middle are duplicates, store
    #   the first half output in an array.

    # * Algorithm *
    # - Determine diamond width: size of letters from A..to_letter
    # - Line components:
    #   - Letter(s)
    #   - Space between letters (start at 0 and increase with each line)
    #   - Total width of each line.
    # - With that information, one can simply center the letter or letters with
    #   spaces between them on a blank line that's as wide as the diamond.
    #   - That will generate the top half of the diamond, including the middle.
    # - To generate the bottom half: append a reversed the top half of lines,
    #   excluding the middle.

    # Output: diamond starting with A, expanding through to_letter, then
    # half above middle reversed.
  end
end
