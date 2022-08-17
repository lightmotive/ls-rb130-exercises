# frozen_string_literal: true

def max_by(enumerable)
  compare_max = nil
  item_max_by = nil

  enumerable.each do |item|
    compare_value = yield(item)
    if compare_max.nil? || compare_value > compare_max
      compare_max = compare_value
      item_max_by = item
    end
  end

  item_max_by
end

p(max_by([1, 5, 3]) { |value| value + 2 } == 5)
p(max_by([1, 5, 3]) { |value| 9 - value } == 1)
p(max_by([1, 5, 3]) { |value| (96 - value).chr } == 1)
p(max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5])
p(max_by([-7]) { |value| value * 3 } == -7)
p(max_by([]) { |value| value + 5 }.nil?)
