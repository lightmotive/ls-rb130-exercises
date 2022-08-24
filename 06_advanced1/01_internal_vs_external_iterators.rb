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

puts 'Output first 5 factorials:'
5.times { puts factorial_enumerator.next }
puts '2 more:', factorial_enumerator.next, factorial_enumerator.next

puts '[Rewind]'
factorial_enumerator.rewind

puts
puts 'Factorials 1-3:'
3.times { puts factorial_enumerator.next }

puts
print 'Enumerator#first(7).to_a: '
p factorial_enumerator.first(7).to_a

puts
puts 'Factorials 4-7 (continued from 1-3):'
4.times { puts factorial_enumerator.next }
# Interesting that external iteration operates independently Enumerable method
# calls on the same object.
