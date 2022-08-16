# frozen_string_literal: true

def drop_while(enumerable)
  keep_searching = true
  enumerable.each_with_object([]) do |args, keep|
    next if keep_searching && yield(args)

    keep_searching = false

    keep << args
  end
end

p(drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6])
p(drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6])
p(drop_while([1, 3, 5, 6]) { true } == [])
p(drop_while([1, 3, 5, 6]) { false } == [1, 3, 5, 6])
p(drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6])
p(drop_while([]) { true } == [])
p(drop_while({ a: 'A', b: 'B' }) { |k, _| k == :a } == [[:b, 'B']])
