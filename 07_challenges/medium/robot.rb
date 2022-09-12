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

class Robot
  NAME_LETTERS = ('A'..'Z').to_a.freeze
  @@generated_names = [].freeze

  def initialize
    # - Assign `@name` to `self.class.random_name`
  end

  def reset
    # - Assign a new random name.
  end

  private

  def random_digit
    # - Generate random digits using rand(10).
  end

  def random_letter
    # - Generate random letters using NAME_LETTERS[rand(26)].
  end

  class << self
    def self.random_name
      # - Generate name randomly using a format /^[A-Z]{2}\d{3}$/
      # - Ensure it wasn't generated before (track across all instances)
      # - save generated name in array for to prevent duplicates
    end
  end
end
