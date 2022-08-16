# frozen_string_literal: true

def count(*args)
  args.reduce(0) { |count, arg| count + (yield(arg) ? 1 : 0) }
end

p(count(1, 3, 6) { |value| value.odd? } == 2)
p(count(1, 3, 6) { |value| value.even? } == 1)
p(count(1, 3, 6, &:even?) == 1)
p(count(1, 3, 6) { |value| value > 6 }.zero?)
p(count(1, 3, 6) { true } == 3)
p(count {  true } == 0)
p(count(1, 3, 6) { |value| value - 6 } == 3)
