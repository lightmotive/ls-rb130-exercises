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
    # ...

    # Output: diamond starting with A, expanding through to_letter, then
    # half above middle reversed.
  end
end
