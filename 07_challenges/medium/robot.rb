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
  def initialize
    # - Assign `@name` to `UniqueName.random`
  end

  def reset
    # - Assign `@name` to `UniqueName.random`
  end

  class << self
    class UniqueName
      NAME_LETTERS = ('A'..'Z').to_a.freeze
      @@generated_names = [].freeze
      # A real factory would want to use a DB to check + store generated names.

      class << self
        def random
          name = String.new

          while name.empty? || unique?(name)
            name = '' # - Generate name randomly using a format /^[A-Z]{2}\d{3}$/
          end

          # - save generated name in array for to prevent duplicates

          name
        end

        private

        def unique?(name)
          # Verify whether name is unique
        end

        def random_digit
          # - Generate random digits using rand(10).
          1
        end

        def random_letter
          # - Generate random letters using NAME_LETTERS[rand(26)].
          1
        end
      end
    end

    def self.random_name; end
  end
end
