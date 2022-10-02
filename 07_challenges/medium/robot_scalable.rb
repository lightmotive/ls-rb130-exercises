# frozen_string_literal: true

# ** robot_scalable.rb **
# Create performance:
#   Init (generate and shuffle all possible names): ~0.63 seconds
#   Generated 676,000 robots in ~22 seconds
#   Avg. robots/second: ~30,000
#   - The ~0.64 second startup performance penalty yields vastly improved
#     generation time and consistent performance regardless of the number of
#     active robots.
# Reset performance:
#   Reset 200 robots in ~4.5 seconds
#   Avg. reset robots/second: ~44
#   - Resetting robots is somewhat slow because it uses **Array#delete* instead
#     of a `bsearch` implementation. See ./robot_scalable.rb, which solves that
#     scalability problem.

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

    use_name!
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

  def use_name!
    name = names_available.shift
    insert_before_idx =
      names_used.bsearch_index { |used| used > name } ||
      names_used.size
    names_used.insert(insert_before_idx, name)
    name
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
