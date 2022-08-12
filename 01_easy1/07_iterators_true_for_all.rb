# frozen_string_literal: true

def all?(enumerable)
  enumerable.each { |*args| return false unless yield(*args) }

  true
end

p all?([1, 3, 5, 6]) { |value| value.odd? } == false
p all?([1, 3, 5, 7]) { |value| value.odd? } == true
p all?([2, 4, 6, 8]) { |value| value.even? } == true
p all?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
p all?([1, 3, 5, 7]) { |_value| true } == true
p all?([1, 3, 5, 7]) { |_value| false } == false
p all?([]) { |_value| false } == true
