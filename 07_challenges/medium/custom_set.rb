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
# - `intersection(CustomSet value)`: return a new CustomSet that contains
#   elements from the current set that are also in the provided set.
# - `difference(CustomSet value)`: return a new CustomSet containing elements
#   *from the current set* that are not in the provided set.
# - `union(CustomSet value)`: return a new CustomSet containing unique elements
#   from both the current and provided sets.

# Examples
# - Reviewed test cases to identify class behaviors and rules.

# Data structure
# - Because this is a simple set of Integer elements, no performance
#   requirements have been defined, and we would probably use Ruby's `Set` class
#   as a collaborator object, let's use an Array as the internal data
#   structure for this exercise.

# Store and compare unique Integer elements with an unspecified order.
class CustomSet
  # - Initialize as an empty set by default. Optionally provide an array of
  #   Integer elements.
  def initialize(elements = [])
    @elements = []
    add_array(elements)
  end

  def empty?
    elements.empty?
  end

  def contains?(element)
    elements.include?(element)
  end

  def add(element)
    elements.push(element) unless contains?(element)
    self
  end

  def ==(other)
    return false if elements.size != other.size

    subset?(other)
  end

  alias eql? ==

  def subset?(other)
    elements.all? { |e| other.contains?(e) }
    # Better performance if we implement a public or protected `sort` method,
    # then compare the sorted results. To build agiley, implement later if
    # needed.
  end

  def disjoint?(other)
    elements.none? { |e| other.contains?(e) }
  end

  def intersection(other)
    elements.each_with_object(self.class.new) do |e, set|
      set.add(e) if other.contains?(e)
    end
  end

  def difference(other)
    elements.each_with_object(self.class.new) do |e, set|
      set.add(e) unless other.contains?(e)
    end
  end

  def union(other)
    set = self.class.new
    set.add_array(to_a).add_array(other.to_a)
  end

  protected

  def size
    elements.size
  end

  def to_a
    elements.dup
  end

  def add_array(elements)
    elements&.uniq&.each(&method(:add))
    self
  end

  private

  attr_reader :elements
end
