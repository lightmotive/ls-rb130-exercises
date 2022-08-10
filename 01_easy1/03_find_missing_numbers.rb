# frozen_string_literal: true

def missing(sorted_integers)
  sorted_integers.each_cons(2).with_object([]) do |(first, second), result|
    between_range = (first + 1)..(second - 1)
    result.concat(between_range.to_a)
  end
end

p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []
