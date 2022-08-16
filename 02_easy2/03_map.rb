# frozen_string_literal: true

require 'set'

def map(enumerable)
  enumerable.each_with_object([]) { |args, mapped| mapped << yield(args) }
end

p(map([1, 3, 6]) { |value| value**2 } == [1, 9, 36])
p(map([]) { |_value| true } == [])
p(map(%w[a b c d]) { |_value| false } == [false, false, false, false])
p(map(%w[a b c d], &:upcase) == %w[A B C D])
p(map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]])
hash = { a: 'A', b: 'B' }
map_hash1 = map(hash) { |key, value| [key, value] }
map_hash2 = map(hash) { |entry| entry }
map_hash_expected = [[:a, 'A'], [:b, 'B']]
p(map_hash1 == map_hash_expected)
p(map_hash2 == map_hash_expected)
p(hash.map { |key, value| [key, value] } == map_hash_expected)
p(hash.map { |entry| entry } == map_hash_expected)
p(map({}) { |entry| entry } == [])
p(map(Set[1, 'c', :s]) { |value| [value] } == [[1], ['c'], [:s]])
