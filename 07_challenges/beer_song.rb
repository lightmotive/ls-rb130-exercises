# frozen_string_literal: true

class BeerSong
  # Private class that encapsulates "verse" attributes and behaviors/templates.
  # ToDo: Internationalize strings in this class.
  class Verse
    def initialize(number)
      @number = number
    end

    def to_s
      <<~VERSE
        #{line1}
        #{line2}
      VERSE
    end

    private

    attr_reader :number

    def excerpt_bottles(bottle_count, is_sentence_start: false)
      no_more = is_sentence_start ? 'No more' : 'no more'
      quantity = bottle_count.zero? ? no_more : bottle_count.to_s
      bottles_string = bottle_count == 1 ? 'bottle' : 'bottles'
      "#{quantity} #{bottles_string} of beer"
    end

    def excerpt_take_down
      "Take #{number == 1 ? 'it' : 'one'} down"
    end

    def line1
      "#{excerpt_bottles(number, is_sentence_start: true)} on the wall, #{excerpt_bottles(number)}."
    end

    def line2
      return "#{excerpt_take_down} and pass it around, #{excerpt_bottles(number - 1)} on the wall." if number.positive?

      "Go to the store and buy some more, #{excerpt_bottles(99)} on the wall."
    end
  end

  private_constant :Verse

  def self.verse(number)
    Verse.new(number).to_s
  end

  def self.verses(first, last)
    first.downto(last).map do |number|
      verse(number)
    end.join("\n")
  end

  def self.lyrics
    # Generate all verses, `verses(99, 0)` with an empty line between each.
  end
end
