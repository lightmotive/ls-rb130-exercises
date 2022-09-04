# frozen_string_literal: true

# * Understand *
# - Within basic class structure below.

class Diamond
  START_LETTER = 'A'

  attr_reader :end_letter

  def initialize(end_letter)
    @end_letter = end_letter_with_validation(end_letter)
  end

  def as_string
    as_lines.join("\n")
  end

  def self.make_diamond(end_letter)
    new(end_letter).as_string
  end

  private

  def as_lines
    lines_top = []

    # * Algorithm *
    letters = START_LETTER..end_letter

    # - Determine diamond width: size of letters from A..end_letter
    # - Line components:
    #   - Letter(s)
    #   - Space between letters (start at 0 and increase with each line)
    #   - Total width of each line.
    # - With that information, one can simply center the letter or letters with
    #   spaces between them on a blank line that's as wide as the diamond.
    #   - That will generate the top half of the diamond, including the middle.
    # - To generate the bottom half: append a reversed the top half of lines,
    #   excluding the middle.

    # Output: diamond starting with A, expanding through end_letter, then
    # half above middle reversed.
    lines_bottom = lines_top[0..-2].reverse
    lines_top + lines_bottom
  end

  def end_letter_with_validation(input)
    raise ArgumentError, "Specify a single uppercase letter after #{START_LETTER}" if input.length > 1

    input_validated = input.upcase
    if input_validated.ord < START_LETTER.ord
      raise ArgumentError, "Letter must be '#{START_LETTER}' or after on the ASCII char table."
    end

    input_validated
  end

  def line(letter, line_length, space_between_letters = nil)
    return letter.center(line_length) if space_between_letters.nil?

    letters = "#{letter}#{' ' * space_between_letters}#{letter}"
    letters.center(line_length)
  end
end
