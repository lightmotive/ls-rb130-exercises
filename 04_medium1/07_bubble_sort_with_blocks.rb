# frozen_string_literal: true

# Fixed comparison algorithm
# With two adjacent elements `first` and `second`:
# - If first <= second:
#   - Skip
# - Otherwise, swap associated first and second elements

# Flexible block comparison algorithm
# With two adjacent elements `first` and `second`:
# - If no block given:
#   - comparison_result = first <=> second
# - else:
#   - comparison_result = yield(first, second)
#     - Pass first and second to block with requirement to return what a combined
#       comparison expression would return (block returns one of the following):
#       - -1 (first is less than second)
#       - 0 (elements are equal)
#       - 1 (first is greater than second)
# - If comparison_result <= 0:
#   - Skip
# - Otherwise, swap associated first and second elements

# rubocop:disable Metrics/MethodLength
def bubble_sort!(array)
  last_index_offset = 2

  loop do
    swapped = false

    0.upto(array.size - last_index_offset) do |idx|
      first = array[idx]
      second = array[idx + 1]
      comparison_result = block_given? ? yield(first, second) : first <=> second
      next if comparison_result <= 0

      array[idx] = second
      array[idx + 1] = first
      swapped = true
    end

    last_index_offset += 1
    break unless swapped
  end
end
# rubocop:enable Metrics/MethodLength

array = [5, 3]
bubble_sort!(array)
p array == [3, 5]

array = [5, 3, 7]
bubble_sort!(array) { |first, second| second <=> first }
p array == [7, 5, 3]

array = [6, 2, 7, 1, 4]
bubble_sort!(array)
p array == [1, 2, 4, 6, 7]

array = [6, 12, 27, 22, 14]
bubble_sort!(array) { |first, second| (first % 7) <=> (second % 7) }
p array == [14, 22, 12, 6, 27]

array = %w[sue Pete alice Tyler rachel Kim bonnie]
bubble_sort!(array)
p array == %w[Kim Pete Tyler alice bonnie rachel sue]

array = %w[sue Pete alice Tyler rachel Kim bonnie]
bubble_sort!(array) { |first, second| first.downcase <=> second.downcase }
p array == %w[alice bonnie Kim Pete rachel sue Tyler]

# Further exploration:
def bubble_sort_by!(array)
  bubble_sort!(array) { |first, second| yield(first) <=> yield(second) }
end

array = %w[sue Pete alice Tyler rachel Kim bonnie]
bubble_sort_by!(array, &:downcase)
p array == %w[alice bonnie Kim Pete rachel sue Tyler]
