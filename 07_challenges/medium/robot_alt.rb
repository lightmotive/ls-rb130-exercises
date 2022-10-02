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
# (host-dependent; these were run on a 2021 M1 Max MacBook Pro):

# ** Test setup **
# # Init performance:
# init_start_time = Time.now

# ** require test file here **

# puts "Init seconds: #{Time.now - init_start_time}"

# robots = []
# generate_count = 676_000

# # Create performance
# create_start_time = Time.now
# puts "Generating #{generate_count} robots..."

# robots.push(Robot.new) while robots.size < generate_count

# create_seconds = Time.now - create_start_time
# puts "Generated #{robots.size} robots in #{create_seconds} seconds (~#{robots.size.fdiv(create_seconds).floor}/sec)"
# puts robots.map(&:name).uniq.size

# # Reset performance
# reset_start_time = Time.now
# robots.shuffle!
# reset_count = 10_000

# puts "Resetting #{reset_count} robots..."
# reset_count.times { robots.shift.reset }

# reset_seconds = Time.now - reset_start_time
# puts "Reset #{reset_count} robots in #{reset_seconds} seconds (#{reset_count.fdiv(reset_seconds)}/sec)"

# ** robot.rb **
# Create performance:
#   Init (names are not pre-generated): negligible
#   Generated 676,000 robots in 47-56 seconds (~12,000-14,000/second)
#   - Analysis: reasonably fast implementation that slows to a crawl when all
#     names are used because it takes time to randomly generate and check what
#     hasn't already been used. Performance will be inconsistent because of that
#     random nature and the binary search algorithm. However, startup time is
#     not impacted, so this would be a good solution for small-scale scenarios.
# Reset performance:
#   X*X Did not finish in a reasonable timeframe; ~2 seconds/reset.
#   - The slower creation time also slows the reset time. With 670K
#     possibilities, the random name implementation would be a deal-breaker
#     in scenarios requiring maximum scale.

# ** robot_alt.rb **
# Create performance:
#   Init (generate and shuffle all possible names): ~0.63 seconds
#   Generated 676,000 robots in ~0.23 seconds (~3,000,000/second)
#   - The ~0.63 second startup performance penalty yields vastly improved
#     creation time and consistent performance regardless of the number of
#     active robots.
# Reset performance:
#   Reset 200 robots in ~4.5 seconds (~44/second)
#   - Resetting robots is somewhat slow because it uses **Array#delete* instead
#     of a binary search implementation. See ./robot_scalable.rb, which solves
#     that scalability problem.

# The robot_alt.rb performance boost carries these trade-offs because it
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
    released_name = names_used.delete(name)
    return self if released_name.nil?

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
end

class Robot
  @@robot_names = RobotNames.new
  attr_reader :name

  def initialize
    @name = @@robot_names.use!
  end

  def reset
    @@robot_names.release!(@name)
    @name = @@robot_names.use!
  end
end
