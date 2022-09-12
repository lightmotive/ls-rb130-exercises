# frozen_string_literal: true

# Write a program that manages robot factory settings.
#
# When robots come off the factory floor, they have no name. The first time you
# boot them up, a random name is generated, such as RX837 or BC811.
#
# Every once in a while, we need to reset a robot to its factory settings,
# which means that their name gets wiped. The next time you ask, it will
# respond with a new random name.
#
# The names must be random; they should not follow a predictable sequence.
# Random names means there is a risk of collisions.
# Your solution should not allow the use of the same name twice when avoidable.

# Understand
# - Behaviors w/ rules:
#   - new:
#     - Assign `@name` to `generate_name`
#       - save generated name in array for to prevent duplicates
#   - reset:
#     - Assign a new random name.
#   - generate_name:
#     - Generate name randomly using a format /^[A-Z]{2}\d{3}$/
#     - Ensure it wasn't generated before (track across all instances)

# Tests
# - Reviewed for additional rules/context calibration.

# Data structure
# - Store upper-case letters as an array for sampling.
# - Save generated names in an array (class variable).

# Algorithm
# - Class const: NAME_LETTERS = ('A'..'Z').to_a.freeze
# - Generate random digits using rand(10).
# - Generate random letters using NAME_LETTERS[rand(26)].
