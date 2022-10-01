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
# start_time_init = Time.now
#
# ...class definition/require statement here...
#
# puts "Init time: #{Time.now - start_time_init}"
#
# robots = []
# start_time = Time.now
# puts 'Generating 676,000 robots...'
#
# robots.push(Robot.new) while robots.size < 676_000
# run_seconds = Time.now - start_time
#
# puts "Generated #{robots.size} robots in #{run_seconds} seconds | " \
#      "Avg. robots/second: #{robots.size.fdiv(run_seconds).floor}"
# puts robots.map(&:name).uniq.size

# ** robot.rb **
# Results: Initialize time: negligible |
#          Generated 676,000 robots in 47-56 seconds |
#          Avg. robots/second: 12,000 - 14,000
# - Reasonably fast, though it slows to a crawl for the last several generated
#   names because it takes time to randomly generate what hasn't already been
#   used. Performance will be inconsistent because of that random nature and
#   the bsearch algorithm. However, startup time is not impacted.

# ** robot_alt.rb **
# Results: Initialize time (generate and shuffle all possible names): ~0.64 seconds |
#          Generated 676,000 robots in ~0.22 seconds |
#          Avg. robots/second: ~3,000,000
# - The ~0.64 second startup performance penalty yields vastly improved
#   generation time and consistent performance.

# The robot_alt.rb performance boost carries these tradeoffs because it
# generates and randomizes all possible names at startup:
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
# - `#use!`: shift a name from a pre-shuffled list of available names, then
#   block that name from further use until released.
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

  def use!
    raise StandardError, 'All names are in use' if names_available.empty?

    name = names_available.shift
    names_used.push(name)

    name
  end

  def release!(name)
    delete_at_idx = names_used_idx(name)
    return if delete_at_idx.nil?

    released_name = names_used.delete_at(delete_at_idx)
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
    char_range.to_a.repeated_permutation(length).to_a.uniq
  end

  def names_used_idx(name)
    names_used.bsearch_index { |used| name <=> used }
  end
end

# Robot with a randomly generated and guaranteed-unique name with reset
# capability. Uses `RobotName` to generate, use, and track usage of names.
#
# Public behaviors:
# - `::new`: assign unused name to `@name`.
# - `#name`: return current `@name` value.
# - `#reset`: release the current name and assign the next unused name to
#   `@name`.
class Robot
  @@robot_names = RobotNames.new
  attr_reader :name

  def initialize
    @name = @@robot_names.use!
  end

  def reset
    @@robot_names.release!(@name)
    # Release current @name first to ensure all possible names are available.
    # Alternatively, `release!` after `use!` to ensure the new name is
    # different; that would reduce possible names by 1.
    @name = @@robot_names.use!
  end
end
