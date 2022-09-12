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
    letters = 2.times.reduce(String.new) { |acc, _| acc << random_letter }
    numbers = 3.times.reduce(String.new) { |acc, _| acc << random_digit.to_s }

    "#{letters}#{numbers}"
  end

  class << self
    NAME_LETTERS = ('A'..'Z').to_a.freeze
    DIGIT_MAX = 9 # min always 0

    private

    def random_digit
      rand(DIGIT_MAX + 1)
    end

    def random_letter
      NAME_LETTERS[rand(NAME_LETTERS.size)]
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
    @name = @@unique.create
  end
end
