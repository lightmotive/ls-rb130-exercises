# * P *
# Input: Initialize class with 3 numeric values.
# Output: A Triangle class that has determined the type of triangle.
#
# Rules (implicit & explicit)
# - sides.length must be 3
# - All sides must be greater than 0
# - Sum of any 2 sides must be greater than the length of the 3rd side.
#
# * E *
# - Tests in test/triangle_test.rb.
#
# * D *
# - Capture sides during init as an array, which makes various initial
#   validations easier.
# - Store triangle type as a string in a `kind` attribute w/ public read and
#   private write.
#
# * A *
# - Validate basic triangle rules during class init. Raise exception if any fail.
# - Determine triangle type:
#   - An equilateral triangle has all three sides the same length.
#   - An isosceles triangle has exactly two sides of the same length.
#   - A scalene triangle has all sides of different lengths.

class Triangle
  attr_reader :sides, :kind

  def initialize(*sides)
    @sides = sides
    validate_sides
    determine_kind
  end

  private

  def validate_sides
    raise ArgumentError, 'Must provide 3 sides as separate arguments.' unless sides.length == 3
    raise ArgumentError, 'All side lengths must be greater than 0.' unless sides.all?(&:positive?)

    unless side_lengths_valid?
      raise ArgumentError,
            'The sum of any 2 side lengths must be greater than the 3rd side length.'
    end
  end

  # Sum of any 2 sides must be greater than the length of the 3rd side.
  def side_lengths_valid?
    is_sequence_valid = ->(sides) { sides.first(2).sum > sides.last }
    return false unless is_sequence_valid.call(sides)
    return false unless is_sequence_valid.call(sides.rotate)
    return false unless is_sequence_valid.call(sides.rotate)

    true
  end

  def determine_kind
    @kind = case sides.uniq.count
            when 1 then 'equilateral'
            when 2 then 'isosceles'
            when 3 then 'scalene'
            end
  end
end
