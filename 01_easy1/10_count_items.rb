# frozen_string_literal: true

def count(enumerable)
  # count = 0
  # enumerable.each { |*args| count += 1 if yield(*args) }
  # count

  # Alternative solution that doesn't use `each`, `loop`, `while`, or `until`:
  enumerable.reduce(0) do |count, args|
    count + (yield(*args) ? 1 : 0)
  end
end

p count([1, 2, 3, 4, 5]) { |value| value.odd? } == 3
p count([1, 2, 3, 4, 5]) { |value| value % 3 == 1 } == 2
p count([1, 2, 3, 4, 5]) { |_value| true } == 5
p count([1, 2, 3, 4, 5]) { |_value| false } == 0
p count([]) { |value| value.even? } == 0
p count(%w[Four score and seven]) { |value| value.size == 5 } == 2
# A few more tests to show that it works with hashes or other objects with multi-arg yields
p count({ k1: 5, k2: 7 }) { |k, v|  k == :k2 && v == 7 } == 1
p count({ k1: 5, k2: 7 }) { |*args| args == [:k1, 5] } == 1
p count({}) { true }.zero?
