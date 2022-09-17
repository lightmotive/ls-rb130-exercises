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
  attr_reader :datum, :next

  def initialize(datum, next_element = nil)
    @datum = datum
    @next = next_element
  end

  def tail?
    @next.nil?
  end
end

# Use `Element` class for linked items.
class SimpleLinkedList
  include Enumerable

  attr_reader :head, :size

  def initialize
    @head = nil
    @size = 0
  end

  def self.from_a(datum_array)
    list = new
    return list if datum_array.nil? || datum_array.empty?

    datum_array.reverse_each { |element| list.push(element) }
    list
  end

  def empty?
    @head.nil?
  end

  def each
    return to_enum { size } unless block_given?
    return if empty?

    element = @head
    loop do
      yield element.datum
      break if element.tail?

      element = element.next
    end
  end

  def push(value)
    @size += 1
    @head = Element.new(value, @head)
    self
  end

  def pop
    element_to_pop = @head
    @head = element_to_pop.next
    @size -= 1
    element_to_pop.datum
  end

  def peek
    @head&.datum
  end

  def reverse
    to_enum.each_with_object(self.class.new) { |datum, list| list.push(datum) }
  end
end
