# frozen_string_literal: true

def factorial_iterator
  factorial = 0
  value = 1

  loop do
    yield value
    factorial += 1
    value *= factorial
  end
end

factorial_enumerator = enum_for(:factorial_iterator)

7.times { puts factorial_enumerator.next }

puts '[Rewind]'
factorial_enumerator.rewind

puts factorial_enumerator.next
puts factorial_enumerator.next
puts factorial_enumerator.next

puts '[Use Enumerator#first - no need to rewind first]'
puts factorial_enumerator.first(7)

puts '[Continue external iteration from last `next` call, before Enumerable#first call]'
puts factorial_enumerator.next, factorial_enumerator.next, factorial_enumerator.next
