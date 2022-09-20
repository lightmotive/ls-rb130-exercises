# frozen_string_literal: true

# Create a custom set type.
#
# Sometimes it is necessary to define a custom data structure of some type,
# like a set. In this exercise you will define your own set type. How it works
# internally doesn't matter, as long as it behaves like a set of unique elements
# that can be manipulated in several well defined ways.
#
# In some languages, including Ruby and JavaScript, there is a built-in Set
# type. For this problem, you're expected to implement your own custom set
# type. Once you've reached a solution, feel free to play around with using
# the built-in implementation of Set.
#
# For simplicity, you may assume that all elements of a set must be numbers.

# Understand
# Create a class to store unique elements with the following behaviors:
# - Store and compare elements in any order.
# - Initialize as an empty set by default. Optionally provide an array of
#   Integer elements.
#   - Remember to prevent duplicate elements.
# - `empty?`: return `true` if the set contains no elements.
# - `contains?(Integer element)`: return `true` if the set contains the
#   provided element.
# - `add(element)`: add element to set if it doesn't already exist.
#   Return `self`.
# - `==`: return `true` if the set contains the same elements *in any order*.
# - alias `eql?` to `==`.
# - `subset?(CustomSet value)`: return `true` if the current CustomSet is a
#   subset of the provided CustomSet arg, regardless of order.
# - `disjoint?(CustomSet value)`: return `true` if the current set shares no
#   elements with the provided set. Return `true` if both sets are empty.
# - `intersection(CustomSet value)`: return a new CustomSet containing matching
#   elements.
# - `difference(CustomSet value)`: return a new CustomSet containing elements
#   *from the current set* that are different from the provided set.
# - `union(CustomSet value)`: return a new CustomSet containing unique elements
#   from both the current and provided sets.

# Examples
# - Reviewed test cases to identify class behaviors and rules.

# Data structure
# - Because this is a simple set of Integer elements, no performance
#   requirements have been defined, and we would probably use Ruby's `Set` class
#   as a collaborator object, let's use an Array as the internal data
#   structure for this exercise.

# Algorithm
