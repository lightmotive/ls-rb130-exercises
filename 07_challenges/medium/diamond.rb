# frozen_string_literal: true

class Diamond
  START_CHAR = 'A'

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

  def end_letter_with_validation(input)
    raise ArgumentError, "Specify a single char at or after #{START_CHAR}" if input.length > 1
    raise ArgumentError, "Char must be '#{START_CHAR}' or after on the ASCII table." if input.ord < START_CHAR.ord

    input
  end

  def as_lines
    top = lines_top
    bottom = lines_bottom(top)
    lines_all_centered(top, bottom)
  end

  def lines_top
    lines = [START_CHAR]
    return lines if end_letter == START_CHAR

    remaining_letters = ((START_CHAR.ord + 1).chr..end_letter).to_a
    space_between_letters = -1
    remaining_letters.each do |letter|
      space_between_letters += 2
      lines << "#{letter}#{' ' * space_between_letters}#{letter}"
    end

    lines
  end

  def lines_bottom(top)
    top[0..-2].reverse
  end

  def lines_all_centered(top, bottom)
    line_length_max = top.last.length
    (top + bottom).map { |line| line.center(line_length_max) }
  end
end
