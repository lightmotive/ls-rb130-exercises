# frozen_string_literal: true

def count(enumerable)
  count = 0
  enumerable.each { |*args| count += 1 if yield(*args) }
  count
end

p count([1, 2, 3, 4, 5]) { |value| value.odd? } == 3
p count([1, 2, 3, 4, 5]) { |value| value % 3 == 1 } == 2
p count([1, 2, 3, 4, 5]) { |_value| true } == 5
p count([1, 2, 3, 4, 5]) { |_value| false } == 0
p count([]) { |value| value.even? } == 0
p count(%w[Four score and seven]) { |value| value.size == 5 } == 2
