# * P *
# Input: Initialize class with 3 numeric values.
# Output: A Triangle class that has determined the type of triangle.
#
# Rules (implicit & explicit)
# - sides.length must be 3
# - All sides must be greater than 0
# - Sum of any 2 sides must be greater than sum of all sides
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
  end

  private

  def validate_sides
    # - sides.length must be 3
    # - All sides must be greater than 0
    # - Sum of any 2 sides must be greater than sum of all sides
  end

  def determine_kind
    #   - An equilateral triangle has all three sides the same length.
    #   - An isosceles triangle has exactly two sides of the same length.
    #   - A scalene triangle has all sides of different lengths.
  end
end
