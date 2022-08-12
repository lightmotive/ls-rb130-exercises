# frozen_string_literal: true

def any?(array)
  array.each { |e| return true if yield(e) }

  false
end

p any?([1, 3, 5, 6]) { |value| value.even? } == true
p any?([1, 3, 5, 7]) { |value| value.even? } == false
p any?([2, 4, 6, 8]) { |value| value.odd? } == false
p any?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p any?([1, 3, 5, 7]) { |_value| true } == true
p any?([1, 3, 5, 7]) { |_value| false } == false
p any?([]) { |_value| true } == false
