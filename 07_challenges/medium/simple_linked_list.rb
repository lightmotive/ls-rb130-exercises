# frozen_string_literal: true

# * Data Structure *
# LIFO:
# - `Element#next` returns an "older" element, e.g.:
#   Element.new(1,
#     Element.new(2,
#       Element.new(3)
#     )
#   )
#   - Or:
# element1 = Element.new(1)
# element2 = Element.new(2, element1)
# element3 = Element.new(3, element2)
# element3.next # => ref to element2
# element2.next # => ref to element1
# element1.next # => nil; `tail?` returns `true`

# For `SimpleLinkedList` class
class Element
  attr_reader :datum, :is_tail
  alias tail? is_tail

  def initialize(datum, next_element = nil)
    @datum = datum
    self.next_element = next_element
  end

  def next
    next_element
  end

  private

  attr_reader :next_element

  def next_element=(element)
    @next_element = element
    @is_tail = element.nil? ? true : false
  end
end

# Use `Element` class for linked items.
class SimpleLinkedList
  attr_reader :head, :size

  def initialize
    @head = nil
    @size = 0
  end

  def push(value)
    # Create a new element that points to the last element
    # Keep track of:
    # - update `@head`, which points to previous @head
    # - increment `@size`
  end

  def pop
    # Return current `@head`
    # - Set `@head` to `@head.next`
    # - Decrement `@size`
  end

  def peek
    # return `@head`
  end

  def reverse
    # head becomes tail: create new set of linked element starting with @head
  end

  def from_a(datum_array)
    # Create linked elements from array elements:
    # - Enumerate through array from last to first so head datum points to
    #   the first element in the array.
  end

  def to_a
    # Iterate through linked elements until reaching the tail,
    # prepending/unshifting the datum of each into a new array.
  end
end
