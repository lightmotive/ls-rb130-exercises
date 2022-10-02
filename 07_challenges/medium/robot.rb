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
#   - Abstracting that responsibility to this class enables reusing `Unique`
#     to ensure any type of generated value (whatever a block returns) is
#     unique in any program. There's probably at least one Gem that provides
#     a more advanced and configurable version of that, but this is a good
#     learning exercise.
# 2. `RobotName`: Statelessly generate a random robot name that matches
#     `/\A[A-Z]{2}\d{3}\z/`.
#   - Not guaranteed to be unique, hence the need for the `Unique` class.
#   - Abstracting that responsibility to this class makes it easier to read,
#     understand, and, perhaps in the future, modify or entirely replace the
#     class to generate robot names with different logic.
# 3. `Robot`: Statefully provide a `name` value and a `reset` behavior.
#   - Initializes a `Unique` class instance with a block that returns
#     `RobotName.generate`; assigns that instance to a class variable to act as
#     a class-level collaborator (`@@unique = Unique.new { RobotName.generate }).
#   - `#reset` generates and assigns a new unique name using `@@unique.create`.
#   - Thanks to the abstractions above, this class is easy to understand and maintain.
#     We can replace the `Unique` class or what the block provides to `Unique` to
#     change important behaviors without wading through a single class that does
#     three different things. Instead, the three major responsibilities are
#     conceptualized into separate classes.

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

  def delete(value)
    delete_at_idx = used_values.bsearch_index do |used_value|
      value <=> used_value
    end
    used_values.delete_at(delete_at_idx) unless delete_at_idx.nil?
  end

  private

  attr_reader :generate_value, :used_values

  def unique?(value)
    return false if value.nil?

    used_values.bsearch { |used_value| value <=> used_value }.nil?
  end

  def save(value)
    insert_before_idx = used_values.bsearch_index do |used_value|
      used_value > value
    end
    if insert_before_idx.nil?
      used_values << value # This is a little faster than inserting at end
    else
      used_values.insert(insert_before_idx, value)
    end
  end
end

# Generate Robot name that matches /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `::generate`: generate and return the random name.
#
# Possible name permutations:
# - For each 2-upper-char letter combination (676 permutations), there are
#   1,000 3-digit number permutations. 676 * 1000 = 676,000 possible names.
# - Randomly generating a name and using `Unique` would slow to crawl with
#   thousands of names to check after each generation, not to mention retrying
#   random generation when a randomly generated name is already taken.
#   Therefore, it would be better to generate all possible permutations, then
#   sample + flag the name as taken. See robot_fast.rb in this file's
#   directory for that implementation.
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
    @name = @@unique.create
  end

  def reset
    @@unique.delete(@name)
    # Delete current @name first to ensure all possible names are available.
    # Alternatively, delete it after to ensure the new name is different;
    # that would reduce possible names by 1.
    @name = @@unique.create
  end
end
