# frozen_string_literal: true

module BeerSong
  # TODO: Internationalize strings in this class.
  class Verse
    def initialize(number)
      @number = number
    end

    def to_s
      return default_verse if number > 2

      case number
      when 2 then two_bottle_verse
      when 1 then one_bottle_verse
      when 0 then zero_bottle_verse
      end
    end

    private

    attr_reader :number

    def default_verse
      <<~VERSE
        #{number} bottles of beer on the wall, #{number} bottles of beer.
        Take one down and pass it around, #{number - 1} bottles of beer on the wall.
      VERSE
    end

    def two_bottle_verse
      <<~VERSE
        2 bottles of beer on the wall, 2 bottles of beer.
        Take one down and pass it around, 1 bottle of beer on the wall.
      VERSE
    end

    def one_bottle_verse
      <<~VERSE
        1 bottle of beer on the wall, 1 bottle of beer.
        Take it down and pass it around, no more bottles of beer on the wall.
      VERSE
    end

    def zero_bottle_verse
      <<~VERSE
        No more bottles of beer on the wall, no more bottles of beer.
        Go to the store and buy some more, 99 bottles of beer on the wall.
      VERSE
    end
  end

  def self.verse(number)
    raise ArgumentError, 'Arg should be in 0..99.' unless (0..99).cover?(number)

    Verse.new(number).to_s
  end

  def self.verses(start, stop)
    verses = start.downto(stop).map { |number| verse(number) }
    verses.join("\n")
  end

  def self.lyrics
    verses(99, 0)
  end
end
