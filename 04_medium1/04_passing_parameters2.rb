# frozen_string_literal: true

# Write a method that takes an array as an argument.
# The method should:
#  - Yield the contents of the array to a block, which
#    - Should assign your block variables in such a way that it ignores the first two elements
#    - Groups all remaining elements as a `raptors` array.

def ignore_first_two(array)
  yield(array)
end

ignore_first_two(%w[raven finch hawk eagle]) do |_, _, *raptors|
  p "Raptors: #{raptors.join(', ')}"
end
