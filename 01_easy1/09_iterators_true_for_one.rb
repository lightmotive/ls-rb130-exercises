# frozen_string_literal: true

def one?(enumerable)
  count = 0

  enumerable.each do |*args|
    count += 1 if yield(*args)
    return false if count > 1
  end
  return true if count == 1

  false
end

p one?([1, 3, 5, 6]) { |value| value.even? } == true
p one?([1, 3, 5, 7]) { |value| value.odd? }  == false
p one?([2, 4, 6, 8]) { |value| value.even? } == false
p one?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p one?([1, 3, 5, 7]) { |_value| true }        == false
p one?([1, 3, 5, 7]) { |_value| false }       == false
p one?([]) { |_value| true }                  == false
