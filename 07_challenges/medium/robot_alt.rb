# frozen_string_literal: true

# This is a higher-performance alternative to the ./robot.rb implementation; it
# defines the same public interface. For this implementation, we don't need the
# added complexity of a `Unique` class. `RobotName` provides a names from a
# pre-generated and shuffled list without tracking what was used.
# A separate class should provide used name, or "online robots", functionality,
# e.g., `RobotFactory`.

# ** See benchmark setup, comparison, and analysis in ./robot_benchmark.rb **

# This exploration also demonstrates the importance of encapsulation, especially
# separation of concerns in this case:
# - There was no need to alter the `Robot` class' public interface.
# - Replacing the `Unique` class was possible with minimal `Robot` class changes.

# *Implementation overview:*
#
# 1. Generate two unique **permutation sets**: one for 2 upper-case letters and
#    one for 3 digits; **map the product** of those sets to an array of joined
#    strings. That `map` return value now contains all possible unique names;
#    save to `names` array (class attribute).
# 2. **Shuffle** `names` to satisfy the randomness requirement.
# 3. **To get/`use!` an available name:** shift the first name from `names`.
# 4. To `reset` a robot and make the name available, append it to `names`.

# Generate and track usage of Robot names matching /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `#use!`: return a name from a pre-shuffled list of available names. The name
#   is removed from that list, so it won't be provided again until released.
# - `#release!(name)`: add the name back to the list of available names;
#   returns `self`.
#
# Possible name permutations:
# - For each 2-upper-char letter combination, of which there are 676
#   permutations (26^2), there are 1,000 3-digit number permutations (10^3).
#   676 * 1000 = 676,000 possible names.
class RobotNames
  def initialize
    initialize_names!
  end

  def use!
    raise StandardError, 'All names are in use' if names.empty?

    names.shift
  end

  def release!(name)
    names << name
    self
  end

  private

  attr_reader :names

  def initialize_names!
    name_possibilities = letter_digit_sequences(2, 3)
    @names = name_possibilities.map do |letters, digits|
      letters.join + digits.join
    end
    @names.shuffle!
  end

  def letter_digit_sequences(letter_count, digit_count)
    letter_permutations = char_permutations('A'..'Z', letter_count)
    digit_permutations = char_permutations(0..9, digit_count)
    letter_permutations.enum_for(:product, digit_permutations) do
      # Calculate size without enumerating:
      letter_permutations.size * digit_permutations.size
    end
  end

  def char_permutations(char_range, length)
    char_range.to_a.repeated_permutation(length).to_a.uniq
  end
end

# Robot with a randomly generated and guaranteed-unique name with reset
# capability. Uses `RobotName` to generate and track usage of names.
#
# Public behaviors:
# - `::new`: assign unused name to `@name`.
# - `#name`: return current `@name` value.
# - `#reset`: release the current name and assign a new one to `@name`.
class Robot
  def self.initialize_factory!
    # This functionality should be provided by a separate class as an
    # encapsulation best practice. For this exercise, we're simply using this
    # class's singleton class to generate and provide unique names.
    #
    # See ./robot_scalable.rb for an example that uses a `RobotFactory` class.
    @@robot_names = RobotNames.new
  end
  initialize_factory!

  attr_reader :name

  def initialize
    @name = @@robot_names.use!
  end

  def reset
    @@robot_names.release!(@name)
    @name = @@robot_names.use!
  end
end
