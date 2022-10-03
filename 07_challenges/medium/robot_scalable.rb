# frozen_string_literal: true

# This is fully scalable alternative to the `robot_alt.rb` implementation.
# The implementation includes Robot::batch_init that forwards a block to
# RobotNames#batch_use!, which then:
# - Activates batch mode, which changes the class behavior to simply append
#   to `names_used` without sorting.
#   - Appending a used name to `names_used` in sorted order slows the process
#     considerably, even when using a binary search algorithm.
# - Yields to a block that can instantiate multiple Robots quickly.
# - Deactivates batch mode.
# - Sorts `names_used` in place.
#   - Sorting a 670K-element array once is much faster than sequentially
#     inserting 670K elements into the correct sorted position.

# Compare the following performance with the benchmarks indicated in
# ./robot_alt.rb. Note that this test setup is slightly different: it uses
# `Robot::batch_init { ... }` to activate "batch mode" in an encapsulated way.

# ** Test setup **
# # - Note `Robot.batch_init { ... }` usage.
#
# Init performance:
# init_start_time = Time.now
#
# ...require robot_scalable.rb here...
#
# puts "Init time: #{Time.now - init_start_time}"
#
# robots = []
# generate_count = 676_000
#
# Create performance
# create_start_time = Time.now
# puts "Generating #{generate_count} robots..."
#
# Robot.batch_init do
#   robots.push(Robot.new) while robots.size < generate_count
# end
#
# create_seconds = Time.now - create_start_time
# puts "Generated #{robots.size} robots in #{create_seconds} seconds (~#{robots.size.fdiv(create_seconds).floor}/sec)"
# puts robots.map(&:name).uniq.size
#
# Reset performance
# reset_start_time = Time.now
# robots.shuffle!
# reset_count = 20_000
#
# puts "Resetting #{reset_count} robots..."
# reset_count.times { robots.shift.reset }
#
# reset_seconds = Time.now - reset_start_time
# puts "Reset #{reset_count} robots in #{reset_seconds} seconds (~#{reset_count.fdiv(reset_seconds).floor}/sec)"

# ** robot_scalable.rb **
# Create performance:
#   Init (generate and shuffle all possible names): ~0.64 seconds
#   Generated 676,000 robots in ~0.45 seconds (~1,500,000/sec)
#   - The ~0.64 second startup performance penalty yields vastly improved
#     generation time and consistent performance regardless of the number of
#     active robots.
#   - It's interesting that this is slightly slower than the ./robot_alt.rb
#     implementation because it has to check `is_batch_mode` with each `use!`
#     invocation. The different is insignificant enough to ignore in this case.
# Reset performance:
#   Reset 20,000 robots in ~2.5 seconds (~8000/sec)
#   - Now that we're using a fast name distribution algorithm and binary search
#     for tracking used names, both batch initialization and batch resetting
#     are fast.

# Generate and track usage of Robot names matching /\A[A-Z]{2}\d{3}\z/.
#
# Public behaviors:
# - `#use!`: shift a name from a pre-shuffled list of available names, then
#   block that name from further use until released.
# - `#batch_use!`: same as `#use!`, but internally optimized for batched
#   invocation.
# - `#release!(name)`: release a previously selected name; returns `self`.
#
# Possible name permutations:
# - For each 2-upper-char letter combination, of which there are 676
#   permutations (26^2), there are 1,000 3-digit number permutations (10^3).
#   676 * 1000 = 676,000 possible names.
class RobotNames
  def initialize
    initialize_names!
    @is_batch_mode = false
  end

  def use!
    raise StandardError, 'All names are in use' if names_available.empty?

    name = names_available.shift

    if is_batch_mode then names_used << name
    else
      insert_before_idx = names_used.bsearch_index { |used| used > name } ||
                          names_used.size
      names_used.insert(insert_before_idx, name)
    end

    name
  end

  def batch_use!
    raise StandardError, 'Provide a block that will invoke `use!` multiple times' unless block_given?

    @is_batch_mode = true
    yield
    @is_batch_mode = false
    names_used.sort!
  end

  def release!(name)
    delete_at_idx = names_used.bsearch_index { |used| name <=> used }
    return if delete_at_idx.nil?

    released_name = names_used.delete_at(delete_at_idx)
    names_available << released_name
    self
  end

  private

  attr_reader :names_available, :names_used, :is_batch_mode

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

  def self.batch_init(&block)
    raise StandardError, "Provide a block that initializes multiple #{name} instances" unless block_given?

    @@robot_names.batch_use!(&block)
  end

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
