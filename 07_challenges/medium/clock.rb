# frozen_string_literal: true

# * Understand *
# Create a clock that doesn't track the date.
#
# Rules:
# - Use only arithmetic operations. Don't use built-in date/time functionality.
# - 24-hour clock.
#   - Hours: 0-23; rolls over to 0 at 24 hours
#   - Minutes: 0-59
#
# Behaviors:
# - ::new(hours, minutes):  values as integers; minutes optional
# - ::at(hours, minutes): self-instantiate, forward args
#   - `Clock` needs to be stateful to enable `to_s`, `+`, and `-`.
# - #+, #-: Add or subtract minutes
# - #== (equivalence): equal if same hours and minutes
# - to_s: format as "hh:mm"

# * Examples/tests *
# Reviewed test cases and extracted rules and behaviors.

# * Data structure *
# - Store hours and minutes as private instance attributes.

# * Algorithm *
