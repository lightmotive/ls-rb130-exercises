# frozen_string_literal: true

# Fixed comparison algorithm
# With two adjacent elements `first` and `second`:
# - If first <= second:
#   - Skip
# - Otherwise, swap associated first and second elements

# Flexible block comparison algorithm
# With two adjacent elements `first` and `second`:
# - Pass first and second to block with requirement to return what a combined
#   comparison expression would return (block returns one of the following):
#   - -1 (first is less than second)
#   - 0 (elements are equal)
#   - 1 (first is greater than second)
# The rest of this algorithm is the same as the fixed comparison algorithm above:
# - If first <= second:
#   - Skip
# - Otherwise, swap associated first and second elements

# rubocop:disable Metrics/MethodLength
def bubble_sort!(array)
  last_index_offset = 2

  loop do
    swapped = false

    0.upto(array.size - last_index_offset) do |idx|
      next if array[idx] <= array[idx + 1]

      array[idx], array[idx + 1] = array[idx + 1], array[idx]
      swapped = true
    end

    last_index_offset += 1
    break unless swapped
  end
end
# rubocop:enable Metrics/MethodLength

array = [5, 3]
bubble_sort!(array)
array == [3, 5]

array = [5, 3, 7]
bubble_sort!(array) { |first, second| first >= second }
array == [7, 5, 3]

array = [6, 2, 7, 1, 4]
bubble_sort!(array)
array == [1, 2, 4, 6, 7]

array = [6, 12, 27, 22, 14]
bubble_sort!(array) { |first, second| (first % 7) <= (second % 7) }
array == [14, 22, 12, 6, 27]

array = %w[sue Pete alice Tyler rachel Kim bonnie]
bubble_sort!(array)
array == %w[Kim Pete Tyler alice bonnie rachel sue]

array = %w[sue Pete alice Tyler rachel Kim bonnie]
bubble_sort!(array) { |first, second| first.downcase <= second.downcase }
array == %w[alice bonnie Kim Pete rachel sue Tyler]
