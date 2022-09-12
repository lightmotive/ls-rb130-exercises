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

# Generate guaranteed unique values using a provided Generator class that
# defines a `generate` method.
# Automatically save generated values. Invoke `Generator.generate` until value
# is not included in used values.
class Unique
  def initialize(generator)
    @generator = generator
    # A real-world class would include a database or other persistent storage to
    # load and save generated names by unique key.
    @used_values = []
  end

  def create
    value = generator.generate until unique?(value)

    save(value)
    value
  end

  def delete(value)
    @used_values.delete(value)
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

# Generate Robot name. Provide to `Unique` class as a generator.
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

# Robot with a randomly generated and guaranteed-unique name.
# `#reset` generates and assigns a new unique name.
class Robot
  @@unique = Unique.new(RobotNameGenerator)
  attr_reader :name

  def initialize
    reset
  end

  def reset
    @@unique.delete(@name)
    @name = @@unique.create
  end
end
