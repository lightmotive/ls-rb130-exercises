# frozen_string_literal: true

# * Understand *
# Create a clock that doesn't track the date.
#
# Rules:
# - Use only arithmetic operations. Don't use built-in date/time functionality.
# - 24-hour clock.
#
# Behaviors:
# - ::new(hours, minutes):  values as integers; minutes optional
# - ::at(hours, minutes): self-instantiate, forward args
#   - `Clock` needs to be stateful to enable `to_s`, `+`, and `-`.
# - #+, #-: Add or subtract minutes
# - #== (equivalence): equal if same minutes
# - to_s: format as "hh:mm"

# * Examples/tests *
# Reviewed test cases and extracted rules and behaviors.

# * Data structure *
# - Store minutes using private instance attribute.
# - #+ and #- should return a new Clock instance.

# * Algorithm *
# MINUTES_PER_DAY = 24 * 60
# - Instantiate with hours = 0, optional minutes = 0.
#   - Calculate total minutes from hours and minutes (helper method).
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
# - minutes_breakdown
#   - Calculate { hours: ..., minutes: ... } from total_minutes.

require 'pry'

class Clock
  HOURS_PER_DAY = 24
  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = HOURS_PER_DAY * MINUTES_PER_HOUR

  def initialize(hours, minutes)
    apply_values(hours, minutes)
  end

  def self.at(hours = 0, minutes = 0)
    new(hours, minutes)
  end

  # rubocop:disable Naming/BinaryOperatorParameterName
  def +(minutes)
    breakdown = minutes_breakdown(total_minutes + minutes)
    self.class.new(breakdown[:hours], breakdown[:minutes])
  end

  def -(minutes)
    self + -minutes
  end
  # rubocop:enable Naming/BinaryOperatorParameterName

  def ==(other)
    total_minutes == other.total_minutes
  end

  def to_s
    breakdown = minutes_breakdown
    "#{format_number(breakdown[:hours])}:#{format_number(breakdown[:minutes])}"
  end

  protected

  attr_reader :total_minutes

  private

  def apply_values(hours, minutes)
    self.total_minutes = (hours * MINUTES_PER_HOUR) + minutes
  end

  def total_minutes=(value)
    @total_minutes = value % MINUTES_PER_DAY
  end

  def minutes_breakdown(total_minutes = nil)
    total_minutes ||= self.total_minutes
    hours = total_minutes / MINUTES_PER_HOUR
    minutes = total_minutes - (hours * MINUTES_PER_HOUR)
    { hours: hours, minutes: minutes }
  end

  def format_number(number)
    number.to_s.rjust(2, '0')
  end
end
