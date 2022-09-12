# frozen_string_literal: true

# Understand
# - Behaviors w/ rules:
#   - new:
#     - Assign `@name` to `random_name`
#       - save generated name in array for to prevent duplicates
#   - reset:
#     - Assign a new random name.
#   - random_name:
#     - Generate name randomly using a format /^[A-Z]{2}\d{3}$/
#     - Ensure it wasn't generated before (track across all instances)

# Tests
# - Reviewed for additional rules/context calibration.

# Data structure
# - Store upper-case letters as an array for sampling.
# - Save generated names in an array (class variable).

# Algorithm
# - Class const: NAME_LETTERS = ('A'..'Z').to_a.freeze
# - Generate random letters using NAME_LETTERS[rand(26)].

# ** Detailed Explanation **
#
# Classes group, or represent a specific relationship between, attributes and methods. Here are the details:
#
# 1. `Unique`: Guarantee uniqueness of any block-provided value.
#   - Particularly useful for randomly generated values.
#   - `initialize` accepts any block that is expected to generate a value
#     (usually random); the block is converted to a Proc and saved to an
#     instance variable to serve as a collaborator.
#   - Abstracting this responsibility to this class enables reusing `Unique`
#     to ensure any type of generated value (whatever a block returns) is
#     unique in any program. There's probably at least one Gem that provides
#     a more advanced and configurable version of this.
# 2. `RobotName`: Statelessly generate a random robot name that matches
#     `/\A[A-Z]{2}\d{3}\z/`.
#   - Not guaranteed to be unique, hence the need for the `Unique` class.
#   - Abstracting this responsibility to this class makes it easier to read,
#     understand, and, perhaps in the future, modify or entirely replace the
#     class to generate robot names with different logic.
# 3. `Robot`: Statefully provide a `name` value and a `reset` behavior.
#   - Initializes a `Unique` class instance with a block that returns
#     `RobotName.generate`; assigns that instance to a class variable to act as
#     a class-level collaborator (`@@unique = Unique.new { RobotName.generate }).
#   - `#reset` generates and assigns a new unique name using `@@unique.create`.
#   - Thanks to the abstractions above, this class is simple and easy to maintain.
#     We can replace the `Unique` class or what the block provides to `Unique` to
#     change important behaviors without wading through a single class that does
#     three different things.

# ** Implementation **

# Guarantee uniqueness of any block-provided value. Particularly useful for
# randomly generated values.
#
# Public behaviors:
# - `::new { any_generated_value }`: block should return a value.
# - `#create`: use the init-provided block to get values until the
#   returned value is not found among previously returned values.
#   It saves the unique value to ensure it isn't returned again, then
#   returns it.
class Unique
  def initialize(&generate_value)
    raise ArgumentError, 'Include block with ::new.' unless block_given?

    @generate_value = generate_value
    # A real-world class would use a database or other persistent storage
    # that loads and saves generated values. E.g., one could override the
    # `used_values`, `unique?`, and `save` methods to polymorphically use this
    # class with an external data source.
    #
    # For this exercise, we'll simply use an array:
    @used_values = []
  end

  def create
    value = generate_value.call until unique?(value)

    save(value)
    value
  end

  private

  attr_reader :generate_value, :used_values

  def unique?(value)
    return false if value.nil?

    !used_values.include?(value)
  end

  def save(value)
    used_values << value
  end
end

# Generate Robot name that matches /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `::generate`: generate and return the random name.
class RobotName
  def self.generate
    name = String.new
    2.times { name << random_letter }
    3.times { name << random_digit.to_s }
    name
  end

  class << self
    LETTER_ORDINAL_RANGE = 65..90
    DIGIT_RANGE = 0..9

    private

    def random_digit
      rand(DIGIT_RANGE)
    end

    def random_letter
      rand(LETTER_ORDINAL_RANGE).chr
    end
  end
end

# Robot with a randomly generated and guaranteed-unique name with
# reset capability. Uses `Unique` to ensure uniqueness of
# `RobotName`-generated names.
#
# Public behaviors:
# - `#name`: return current `@name` value.
# - `#reset`: generate a new unique name and assign it to `@name`.
class Robot
  @@unique = Unique.new { RobotName.generate }
  attr_reader :name

  def initialize
    reset
  end

  def reset
    @name = @@unique.create
  end
end
