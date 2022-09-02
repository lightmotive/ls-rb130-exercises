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
    end

    private

    attr_reader :number

    def excerpt_bottles_of_beer(bottle_count)
      # - Account for plurality:
      #   "1 bottle of beer on the wall, 1 bottle of beer.\n" \
      #   "Take it down and pass it around, no more bottles of beer on the wall.\n"
      # - Account for 0:
      #   "No more bottles of beer on the wall, no more bottles of beer.\n" \
      #   "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
      # ...
      # return `n` bottle(s) of beer
    end

    def line1
      # "#{bottles_of_beer(number)} on the wall, #{bottles_of_beer(number)}\n"
    end

    def line2
      # - If number.positive?:
      #   - "Take it down and pass it around, #{bottles_of_beer(number - 1)} on the wall.\n"
      # - Else:
      #   - "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
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
