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

# * Algorithm *
# MINUTES_PER_DAY = 24 * 60
# - Instantiate with hours = 0, optional minutes = 0.
#   - Calculate total minutes from hours and minutes (helper method).
# - `::at` method for convenient
#   - Self-instantiate.
# - #+ and #-: add or subtract minutes
#   - Add to @total_minutes and set attr.
# - #==
#   - Compare total_minutes attrs.
# - #to_s
#   - format as "hh:mm"
#
# Key helper methods:
# - total_minutes=(value)
#   - @total_minutes = value mod (MINUTES_PER_DAY).
# - time_values
#   - Calculate { hours: ..., minutes: ... } from total_minutes.
