# frozen_string_literal: true

def zip(arr1, arr2)
  arr1.each_with_index.with_object([]) do |(e, i), zipped|
    zipped << [e, arr2[i]]
  end
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
