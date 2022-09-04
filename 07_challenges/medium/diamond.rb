# frozen_string_literal: true

class Diamond
  START_LETTER = 'A'

  attr_reader :end_letter

  def initialize(end_letter)
    @end_letter = end_letter_with_validation(end_letter)
  end

  def self.make_diamond(end_letter)
    new(end_letter).as_string
  end

  def as_string
    "#{as_lines.join("\n")}\n"
  end

  private

  def as_lines
    lines_top = [START_LETTER]
    return lines_top if end_letter == START_LETTER

    remaining_letters = ((START_LETTER.ord + 1).chr..end_letter).to_a
    space_between_letters = 1
    lines_top += remaining_letters.each_with_object([]) do |letter, lines|
      lines << "#{letter}#{' ' * space_between_letters}#{letter}"
      space_between_letters += 2
    end

    line_length = space_between_letters
    lines_bottom = lines_top[0..-2].reverse
    (lines_top + lines_bottom).map { |line| line.center(line_length) }
  end

  def end_letter_with_validation(input)
    raise ArgumentError, "Specify a single char at or after #{START_LETTER}" if input.length > 1
    raise ArgumentError, "Char must be '#{START_LETTER}' or after on the ASCII table." if input.ord < START_LETTER.ord

    input
  end
end
