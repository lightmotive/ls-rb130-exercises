# frozen_string_literal: true

require 'set'

def map(enumerable)
  enumerable.each_with_object([]) { |(*args), mapped| mapped << yield(*args) }
end

p(map([1, 3, 6]) { |value| value**2 } == [1, 9, 36])
p(map([]) { |_value| true } == [])
p(map(%w[a b c d]) { |_value| false } == [false, false, false, false])
p(map(%w[a b c d], &:upcase) == %w[A B C D])
p(map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]])
p(map({ a: 'A', b: 'B' }) { |key, value| [key, value] } == [[:a, 'A'], [:b, 'B']])
p(map({ a: 'A', b: 'B' }) { |*entry| entry } == [[:a, 'A'], [:b, 'B']])
p(map(Set[1, 'c', :s]) { |value| [value] } == [[1], ['c'], [:s]])
