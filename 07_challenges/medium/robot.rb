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

# Generate guaranteed unique values using any provided class that defines
# a `generate` method. This class is useful when `generate` does return unique
# values, such as randomly generated values.
#
# Public behaviors:
# - `::new(generator)`: `generator` must be a class or module that defines
#   a `generate` method that returns different, usually random, values.
# - `#create`: invoke `generator.generate` until returned value is not found
#   among previously created and returned values. It then saves the unique
#   value to ensure it isn't returned again, then returns it.
class Unique
  def initialize(generator)
    @generator = generator
    # A real-world class would use a database or other persistent storage
    # that loads and saves generated values. E.g., one could override the
    # `used_values`, `unique?`, and `save` methods to polymorphically use this
    # class with an external data source.
    #
    # For this exercise, we'll simply use an array:
    @used_values = []
  end

  def create
    value = generator.generate until unique?(value)

    save(value)
    value
  end

  private

  attr_reader :generator, :used_values

  def unique?(value)
    return false if value.nil?

    !used_values.include?(value)
  end

  def save(value)
    used_values << value
  end
end

# Generate Robot name. Provide to `Unique` class as the collaborator for value
# generation.
#
# Public behaviors:
# - `::generate`: generate a random string that matches /\A[A-Z]{2}\d{3}\z/
class RobotNameGenerator
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
# reset capability.
#
# Public behaviors:
# - `#name`: return current `@name` attribute.
# - `#reset`: generates a new unique name and assigns it to `@name`.
class Robot
  @@unique = Unique.new(RobotNameGenerator)
  attr_reader :name

  def initialize
    reset
  end

  def reset
    @name = @@unique.create
  end
end
