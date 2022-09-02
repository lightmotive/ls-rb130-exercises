# frozen_string_literal: true

class BeerSong
  # Private class that encapsulates verse attributes and behaviors/templates.
  class Verse
    def initialize(number)
      @number = number
    end

    def to_s
      # Generate specific verse with this format:
      #   "2 bottles of beer on the wall, 2 bottles of beer.\n" \
      #   "Take one down and pass it around, 1 bottle of beer on the wall.\n"
      # - Account for plurality:
      #   "1 bottle of beer on the wall, 1 bottle of beer.\n" \
      #   "Take it down and pass it around, no more bottles of beer on the wall.\n"
      # - Account for 0:
      #   "No more bottles of beer on the wall, no more bottles of beer.\n" \
      #   "Go to the store and buy some more, 99 bottles of beer on the wall.\n"

      # One can decompose a verse into these components:
      # - bottles_of_beer: `n` bottle(s) of beer
      #   - First line template:
      #     "#{bottles_of_beer} on the wall, #{bottles_of_beer}\n"
      #   - Second line template:
      #     - If number.positive?:
      #       - "Take it down and pass it around, #{bottles_of_beer} on the wall.\n"
      #     - Else:
      #       - "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    end

    private

    attr_reader :number

    def line1
      # ...
    end

    def line2
      # ...
    end
  end
  private_constant :Verse

  def self.verse(number)
    # Use `Verse` class
  end

  def self.verses(first, last)
    # generate verses from first..last with an empty line between each.
  end

  def self.lyrics
    # Generate all verses, `verses(99, 0)` with an empty line between each.
  end
end
