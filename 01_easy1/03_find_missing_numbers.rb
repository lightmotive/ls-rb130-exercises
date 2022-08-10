# frozen_string_literal: true

def missing(sorted_integers)
  first = sorted_integers.first
  last = sorted_integers.last
  (first..last).reject { |n| sorted_integers.include?(n) }
end

p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []
