# frozen_string_literal: true

def zip(arr1, arr2)
  zipped = []

  arr1.each_with_index do |e, i|
    zipped << [e, arr2[i]]
  end

  zipped
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
