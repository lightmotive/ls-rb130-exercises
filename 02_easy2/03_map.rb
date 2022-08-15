# frozen_string_literal: true

def map(array)
  array.each_with_object([]) { |e, mapped| mapped << yield(e) }
end

p(map([1, 3, 6]) { |value| value**2 } == [1, 9, 36])
p(map([]) { |_value| true } == [])
p(map(%w[a b c d]) { |_value| false } == [false, false, false, false])
p(map(%w[a b c d]) { |value| value.upcase } == %w[A B C D])
p(map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]])
