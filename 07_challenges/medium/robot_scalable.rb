# frozen_string_literal: true

# This is fully scalable alternative to the `robot_alt.rb` implementation.
#
# ** Scale problem overview **
# Initializing many Robot instances in rapid succession, such as when
# rebooting an entire Robot factory, is CPU-intensive. So is resetting a batch
# of robots.
#
# The ./robot_alt.rb implementation solved the problem of quickly initializing
# robots, but left one problem unsolved: efficiently resetting a batch of
# robots. That's because it doesn't try to maintain `names_used` sort order,
# which means it can't use **Array#bsearch** to delete names using a binary
# search algorithm.
#
# In order to do that, the `use!` method needs to modify `names_used << name` to
# insert a name at the sorted position using binary search. But doing that alone
# would slow down batch initialization due to many sequential, and repetitive,
# `names_used` array scans and inserts. To solve that completely, this
# implementation makes 2 changes to ./robot_alt.rb:
# - It uses binary search in `#use!` to insert used names in sorted order.
# - It offers a `#batch_use!` method that essentially deactivates sorted insert
#   into `names_used`. When the batch is complete, it sorts the `names_used`
#   array once when batch mode ends. Sorting that array once is much faster than
#   sequentially inserting many elements into the correct sorted position,
#   especially for large arrays.
#
# ** Implementation overview **
# - **Robot::batch_init** method accepts a block that initializes a batch of
#   robots.
#   - **Robot::batch_init** forwards the block to **RobotNames#batch_use!**,
#     which activates batch mode in an encapsulated way and does the
#     following within the `RobotNames` class:
#     - Activates batch mode, which will temporarily modify `use!` method
#       behavior to simply append to `names_used` array without maintaining
#       sort order.
#     - Yields to a block that can instantiate many Robots at once.
#     - Deactivates batch mode.
#     - Sorts `names_used` in place.

# ** See benchmark setup, comparison, and analysis in ./robot_bm.rb

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
  def self.initialize_factory!
    @@robot_names = RobotNames.new
  end
  initialize_factory!

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
