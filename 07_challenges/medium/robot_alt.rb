# frozen_string_literal: true

# This is an alternative to the implementation in `robot.rb`.
# It passes the same `./test/robot_test.rb` tests that `robot.rb` passed; see
# `./test/robot_fast_test.rb`.
# For this implementation, we don't need the added complexity of a `Unique`
# class. `RobotName` provides shuffled names and tracks which are used.

# Surprisingly, this implementation has a significantly slower runtime after
# generating 32k robots when compared with `robot.rb`.
# It also carries the significant tradeoffs of slower startup time and
# higher initial memory usage because it generates and stores all names when
# the program first runs.

# This implementation is disadvantaged when generating random names like this.
# Perhaps it would have an advantage if name generation was complex...but even
# then, we could use a GUID library to generate random names without
# significant tradeoffs.

# Anyway, fun way to practice with the Ruby language and a reminder of the
# importance of encapsulation, especially separation of concerns in this case:
# - There was no need to alter the `Robot` class' public interface.
# - Replacing the `Unique` class was possible with minimal `Robot` class changes.

# Generate and track usage of Robot names matching /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `#select!`: randomly select a name that hasn't been used, and make it
#   unavailable for use until released.
# - `#release!(name)`: release a previously selected name; returns `self`.
#
# Possible name permutations:
# - For each 2-upper-char letter combination (676 permutations), there are
#   1,000 3-digit number permutations. 676 * 1000 = 676,000 possible names.
class RobotNames
  def initialize
    initialize_names!
  end

  def select!
    raise StandardError, 'All names are in use' if names_available.empty?

    name = names_available.shift
    names_used.push(name)

    name
  end

  def release!(name)
    released_name = names_used.delete(name)
    return nil if released_name.nil?

    names_available.push(released_name)
    self
  end

  private

  attr_reader :names_available, :names_used

  def initialize_names!
    @names_available = letter_digit_sequences(2, 3).map do |letters, digits|
      letters.join + digits.join
    end.shuffle
    @names_used = []
  end

  def letter_digit_sequences(letter_count, digit_count)
    letter_permutations = char_permutations('A'..'Z', letter_count)
    digit_permutations = char_permutations(0..9, digit_count)
    letter_permutations.enum_for(:product, digit_permutations)
  end

  def char_permutations(char_range, length)
    chars = char_range.to_a
    (chars * length).permutation(length).to_a.uniq
  end
end

# Robot with a randomly selected and guaranteed-unique name with
# reset capability. Uses `RobotName` to generate, select, and track usage of
# names.
#
# Public behaviors:
# - `#name`: return current `@name` value.
# - `#reset`: randomly select a name not already in use and assign it to
#   `@name`.
class Robot
  @@robot_names = RobotNames.new
  attr_reader :name

  def initialize
    reset
  end

  def reset
    @@robot_names.release!(@name)
    # Release current @name first to ensure all possible names are available.
    # Alternatively, `release!` after `select!` to ensure the new name is
    # different; that would reduce possible names by 1.
    @name = @@robot_names.select!
  end
end
