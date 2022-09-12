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

class RobotName
  @@generated_names = []
  # A real factory would want to use a DB to check + store generated names.

  class << self
    NAME_LETTERS = ('A'..'Z').to_a.freeze

    def random
      name = generate_random until unique?(name)

      save(name)
      name
    end

    private

    def generate_random
      letters = 2.times.reduce(String.new) { |acc, _| acc << random_letter }
      numbers = 3.times.reduce(String.new) { |acc, _| acc << random_digit.to_s }

      "#{letters}#{numbers}"
    end

    def unique?(name)
      return false if name.nil?

      !@@generated_names.include?(name)
    end

    def save(name)
      @@generated_names << name
    end

    def random_digit
      rand(10)
    end

    def random_letter
      NAME_LETTERS[rand(26)]
    end
  end
end

class Robot
  attr_reader :name

  def initialize
    reset
  end

  def reset
    @name = RobotName.random
  end
end
