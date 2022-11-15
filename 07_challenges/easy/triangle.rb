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

    return if side_lengths_valid?

    raise ArgumentError,
          'The sum of any 2 side lengths must be greater than the 3rd side length.'
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

class Triangle2
  attr_reader :sides, :kind

  # def initialize(*sides)
  # The splat approach above is inappropriate because we want
  # "exactly 3 args," not "any number of args" as splat conveys.
  def initialize(side1, side2, side3)
    @sides = [side1, side2, side3]
    validate_sides
    determine_kind
  end

  private

  def validate_sides
    # raise ArgumentError, 'Must provide 3 sides as separate arguments.' unless sides.length == 3
    # - Check above is unnecessary because `initialize` now ensures 3 sides.
    raise ArgumentError, 'All side lengths must be greater than 0.' unless sides.min.positive?

    return if side_lengths_valid?

    raise ArgumentError,
          'The sum of any 2 side lengths must be greater than the 3rd side length.'
  end

  def side_lengths_valid?
    # sorted = sides.sort
    # sorted.first(2).sum > sorted.last
    # The two lines above can be syntactically and computationally simplified to:
    sides.sum > 2 * sides.max
    # See notes below class for details.
  end

  def determine_kind
    @kind = case sides.uniq.count
            when 1 then 'equilateral'
            when 2 then 'isosceles'
            else 'scalene'
            end
  end
end

# * Notes *
# Comments: https://launchschool.com/exercises/4c45ef4c#solution-comment-f59390df

# It might interest you to know that my initial solution compared the sum of
# the first two sides with the last side in a local lambda
# (is_sequence_valid = ->(sides) { sides.first(2).sum > sides.last }),
# then cleverly rotated the array to compare the remaining two sequences using
# the same lambda...but that required more code and was 5-6 times slower than
# using the theoretical mathematical shortcut I had forgotten:
# the sum of the 2 shortest sides must be greater than the longest side
# (source: https://www.mathwarehouse.com/geometry/triangles/triangle-inequality-theorem-rule-explained.php#:%7E:text=do%20i%20have%20to%20always%20check%20all%203%20sets%3F),
# excluding degenerate triangles that have zero area
# (source: https://en.wikipedia.org/wiki/Triangle_inequality#:%7E:text=this%20statement%20permits%20the%20inclusion%20of%20degenerate%20triangles%2C%20but%20some%20authors%2C%20especially%20those%20writing%20about%20elementary%20geometry%2C%20will%20exclude%20this%20possibility%2C%20thus%20leaving%20out%20the%20possibility%20of%20equality.).

# Other student submissions for performance comparisons:

class Triangle3
  def initialize(one, two, three)
    @arr = [one, two, three].sort
    raise ArgumentError if @arr.any? { |x| x <= 0 } || @arr[0] + @arr[1] <= @arr[2]
  end

  def kind
    return 'equilateral' if @arr.uniq.length == 1

    @arr.uniq.length == 2 ? 'isosceles' : 'scalene'
  end
end

class Triangle4
  def initialize(s1, s2, s3)
    @sides = [s1, s2, s3]

    raise ArgumentError, 'All sides must be greater than zero' if @sides.any? { |s| s <= 0 }
    return unless @sides.sum <= @sides.max * 2

    raise ArgumentError, 'Invalid side values'
  end

  def kind
    %w[equilateral isosceles scalene][@sides.uniq.size - 1]
  end
end

require_relative '../../../ruby-common/test'
require_relative '../../../ruby-common/benchmark_report'

TESTS = [{ input: [2, 2, 2], expected_output: 'equilateral' },
         { input: [10, 10, 10], expected_output: 'equilateral' },
         { input: [4, 4, 3], expected_output: 'isosceles' },
         { input: [20, 20, 17], expected_output: 'isosceles' },
         { input: [5, 4, 3], expected_output: 'scalene' },
         { input: [12, 11, 10], expected_output: 'scalene' },
         { input: [12, 11, 2], expected_output: 'scalene' }].freeze
# { input: [10, 4, 3], expected_output: raises expected exception... }

run_tests('Triangle', TESTS, ->(input) { Triangle.new(*input).kind })
run_tests('Triangle2', TESTS, ->(input) { Triangle2.new(*input).kind })
run_tests('Triangle3', TESTS, ->(input) { Triangle3.new(*input).kind })
run_tests('Triangle4', TESTS, ->(input) { Triangle4.new(*input).kind })

benchmark_report(TESTS,
                 [{ label: 'Triangle', method: ->(input) { Triangle.new(*input).kind } },
                  { label: 'Triangle2', method: ->(input) { Triangle2.new(*input).kind } },
                  { label: 'Triangle3', method: ->(input) { Triangle3.new(*input).kind } },
                  { label: 'Triangle4', method: ->(input) { Triangle4.new(*input).kind } }],
                 iterations: 5000)
