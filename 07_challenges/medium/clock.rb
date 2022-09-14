# frozen_string_literal: true

# * Understand *
# Create a clock that doesn't track the date.
#
# Rules:
# - Use only arithmetic operations. Don't use built-in date/time functionality.
# - 24-hour clock.
#
# Behaviors:
# - ::new(hour, minute):  values as integers; minute optional
# - ::at(hour, minute): self-instantiate, forward args
#   - `Clock` needs to be stateful to enable `to_s`, `+`, and `-`.
# - #+, #-: Add or subtract minutes
# - #== (equivalence): equal if minutes are equal
# - to_s: format as "hh:mm"

# * Examples/tests *
# Reviewed test cases and extracted rules and behaviors.

# * Data structure *
# - Store minutes using private instance attribute.
# - #+ and #- should return a new Clock instance.

# * Algorithm *
# MINUTES_PER_DAY = 24 * 60
# - Instantiate with hour = 0, optional minute = 0.
#   - Calculate total minutes from hour and minute args (helper method).
# - `::at` method for convenient
#   - Self-instantiate.
# - #+ and #-: add or subtract minutes
#   - Add to or subtract from @total_minutes and invoke `total_minutes=`.
# - #==
#   - Compare total_minutes attrs.
# - #to_s
#   - format as "hh:mm"
#
# Key helper methods:
# - total_minutes=(value)
#   - @total_minutes = value mod (MINUTES_PER_DAY).

class Clock
  HOURS_PER_DAY = 24
  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = HOURS_PER_DAY * MINUTES_PER_HOUR

  attr_reader :hour, :minute

  def initialize(hour, minute)
    self.total_minutes = (hour * MINUTES_PER_HOUR) + minute
  end

  def self.at(hour, minute = 0)
    new(hour, minute)
  end

  # rubocop:disable Naming/BinaryOperatorParameterName
  def +(minute)
    self.class.new(0, total_minutes + minute)
  end

  def -(minute)
    self.class.new(0, total_minutes - minute)
  end
  # rubocop:enable Naming/BinaryOperatorParameterName

  def ==(other)
    total_minutes == other.total_minutes
  end

  def to_s
    format('%<hour>02d:%<minute>02d', self)
  end

  def to_hash
    { hour: hour, minute: minute }
  end

  protected

  attr_reader :total_minutes

  private

  def total_minutes=(value)
    @total_minutes = value % MINUTES_PER_DAY
    @hour, @minute = @total_minutes.divmod(MINUTES_PER_HOUR)
  end
end
