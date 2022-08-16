# frozen_string_literal: true

# Implementation for Array-like objects only
def drop_while(array)
  keep_from_idx = array.each_with_index.reduce(0) do |_, (element, idx)|
    break idx unless yield(element)

    idx + 1
  end

  array[keep_from_idx..]
end

p(drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6])
p(drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6])
p(drop_while([1, 3, 5, 6]) { true } == [])
p(drop_while([1, 3, 5, 6]) { false } == [1, 3, 5, 6])
p(drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6])
p(drop_while([]) { true } == [])

# **Implementation for any Enumerable object:**
def drop_while_with_enum_support(enumerable)
  keep_searching = true
  enumerable.each_with_object([]) do |args, keep|
    next if keep_searching && yield(args)

    keep_searching = false
    keep << args
  end
end

p(drop_while_with_enum_support([1, 3, 5, 6]) { |value| value.odd? } == [6])
p(drop_while_with_enum_support([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6])
p(drop_while_with_enum_support([1, 3, 5, 6]) { true } == [])
p(drop_while_with_enum_support([1, 3, 5, 6]) { false } == [1, 3, 5, 6])
p(drop_while_with_enum_support([1, 3, 5, 6]) { |value| value < 5 } == [5, 6])
p(drop_while_with_enum_support([]) { true } == [])
p(drop_while_with_enum_support({ a: 'A', b: 'B' }) { |k, _| k == :a } == [[:b, 'B']])
