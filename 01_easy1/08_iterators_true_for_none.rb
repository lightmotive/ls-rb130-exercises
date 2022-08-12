# frozen_string_literal: true

require_relative '06_iterators_true_for_any'

def none?(enumerable, &block)
  !any?(enumerable, &block)
end

p none?([1, 3, 5, 6]) { |value| value.even? } == false
p none?([1, 3, 5, 7]) { |value| value.even? } == true
p none?([2, 4, 6, 8]) { |value| value.odd? } == true
p none?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
p none?([1, 3, 5, 7]) { |_value| true } == false
p none?([1, 3, 5, 7]) { |_value| false } == true
p none?([]) { |_value| true } == true
