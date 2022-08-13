# frozen_string_literal: true

def any?(enumerable)
  enumerable.each { |*args| return true if yield(*args) }

  false
end

return unless __FILE__ == $PROGRAM_NAME

p any?([1, 3, 5, 6]) { |value| value.even? } == true
p any?([1, 3, 5, 7]) { |value| value.even? } == false
p any?([2, 4, 6, 8]) { |value| value.odd? } == false
p any?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p any?([1, 3, 5, 7]) { |_value| true } == true
p any?([1, 3, 5, 7]) { |_value| false } == false
p any?([]) { |_value| true } == false
p any?({ k1: [1, 3, 5, 6] }) { |_, v| v.any?(&:even?) } == true
