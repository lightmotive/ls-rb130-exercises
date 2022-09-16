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
    raise ArgumentError, 'All side lengths must be greater than 0.' unless sides.min.positive?

    unless side_lengths_valid?
      raise ArgumentError,
            'The sum of any 2 side lengths must be greater than the 3rd side length.'
    end
  end

  # Sum of any 2 sides must be greater than the length of the 3rd side.
  # Shortcut available when side lengths are sorted:
  # - Sum of the 2 shortest side lengths must be greater than the longest side length.
  def side_lengths_valid?
    sorted = sides.sort
    sorted.first(2).sum > sorted.last
  end

  def determine_kind
    @kind = case sides.uniq.count
            when 1 then 'equilateral'
            when 2 then 'isosceles'
            else 'scalene'
            end
  end
end

# class Triangle2
#   def initialize(one, two, three)
#     @arr = [one, two, three].sort
#     raise ArgumentError if @arr.any? { |x| x <= 0 } || @arr[0] + @arr[1] <= @arr[2]
#   end

#   def kind
#     return 'equilateral' if @arr.uniq.length == 1

#     @arr.uniq.length == 2 ? 'isosceles' : 'scalene'
#   end
# end

# require_relative '../../../ruby-common/benchmark_report'

# TESTS = [{ input: [2, 2, 2], expected_output: 'equilateral' },
#          { input: [10, 10, 10], expected_output: 'equilateral' },
#          { input: [4, 4, 3], expected_output: 'isosceles' },
#          { input: [20, 20, 17], expected_output: 'isosceles' },
#          { input: [5, 4, 3], expected_output: 'scalene' },
#          { input: [12, 11, 10], expected_output: 'scalene' }]

# benchmark_report(TESTS,
#                  [{ label: 'Triangle', method: ->(input) { Triangle.new(*input).kind } },
#                   { label: 'Triangle2', method: ->(input) { Triangle2.new(*input).kind } }],
#                  iterations: 5)
