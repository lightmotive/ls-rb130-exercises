# frozen_string_literal: true

# This is a higher-performance alternative to the `robot.rb` implementation.
# It passes the same `./test/robot_test.rb` tests because the `Robot` class uses
# the same public interface; see `./test/robot_fast_test.rb`.
# For this implementation, we don't need the added complexity of a `Unique`
# class. `RobotName` provides a names from a pre-generated and shuffled list,
# then tracks which names are used.

# The performance of this implementation is drastically better because it
# doesn't need to randomly generate a name and check whether that name has
# already been used. Here's a relative performance comparison
# (host-dependent):

# - Test setup:
# robots = []
# start_time = Time.now
# puts 'Generating 676,000 robots...'
#
# robots.push(Robot.new) while robots.size < 676_000
# seconds_elapsed = Time.now - start_time
#
# puts "Generated #{robots.size} robots in #{seconds_elapsed} seconds | " \
#      "Avg. robots/second: #{robots.size.fdiv(seconds_elapsed).floor}"
# puts robots.map(&:name).uniq.size

# ** robot.rb **
# Results: Generated 676,000 robots in 51-56 seconds | Avg. robots/second: 12,000 - 13,000
# - Reasonably fast, though it slows to a crawl for the last several generated
#   names because it takes time to randomly generate what hasn't already been
#   used. Performance will be inconsistent because of that random nature and
#   the bsearch algorithm.

# ** robot_alt.rb **
# Results: Generated 676,000 robots in about 0.18 seconds | Avg. robots/second: about 3,680,000
# - Consistently fast through the end. Total time includes startup time for
#   generating all possible names.

# The robot_alt.rb performance boost carries these tradeoffs because it
# generates and stores all possible names at startup:
# - Slightly slower startup time; probably not a problem in a scenario where a
#   class/factory is initialized only occasionally.
# - Higher initial memory usage; we're not storing a lot of data, so it likely
#   wouldn't be an issue.

# Choosing the best implementation would require knowing how many robots would
# be online at once, and how quickly those robots would need to be brought
# online.

# This exploration also demonstrates the importance of encapsulation, especially
# separation of concerns in this case:
# - There was no need to alter the `Robot` class' public interface.
# - Replacing the `Unique` class was possible with minimal `Robot` class changes.

# *Implementation overview:*
#
# 1. Generate two unique **permutation sets**: one for 2 upper-case letters and
#    one for 3 digits; **map the product** of those sets to an array of joined
#    strings. That `map` return value now contains all possible unique names;
#    save to `names_available` attribute.
# 2. **Shuffle** `names_available` to satisfy the randomness requirement.
# 3. **To get an available name:** shift the first name from `names_available`,
#    saving it to another array assigned to a `names_used` attribute before
#    returning the name. (Technically, `names_used` isn't necessary in this
#     context, but a real-world implementation would probably need to keep track
#     of what has been "used.")
# 4. To `reset` a robot and make the name available, delete the provided name
#    from the `names_used` array and add it to the end of the `names_available`
#    array.

# Generate and track usage of Robot names matching /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `#select!`: select a name from a pre-shuffled list of available names, then
#   make that name unavailable for use until released.
# - `#release!(name)`: release a previously selected name; returns `self`.
#
# Possible name permutations:
# - For each 2-upper-char letter combination, of which there are 676
#   permutations (26^2), there are 1,000 3-digit number permutations (10^3).
#   676 * 1000 = 676,000 possible names.
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
    name_possibilities = letter_digit_sequences(2, 3)
    @names_available = name_possibilities.map do |letters, digits|
      letters.join + digits.join
    end
    @names_available.shuffle!
    @names_used = []
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
    @name = @@robot_names.select!
  end

  def reset
    @@robot_names.release!(@name)
    # Release current @name first to ensure all possible names are available.
    # Alternatively, `release!` after `select!` to ensure the new name is
    # different; that would reduce possible names by 1.
    @name = @@robot_names.select!
  end
end
