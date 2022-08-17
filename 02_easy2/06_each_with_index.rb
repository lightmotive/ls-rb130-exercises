# frozen_string_literal: true

require 'minitest/autorun'

# - Iterate over collection members.
# - Yield each element and its index to the block as separate arguments (unlike Hash#each, which yields an array).
# - The value returned by the block is not used.
# - Return a reference to the original collection.
#
# Your method may use #each, #each_with_object, #inject, loop, for, while, or
# until to iterate through the Array passed in as an argument, but must not use
# any other methods that iterate through an Array or any other collection.

def each_with_index(enumerable)
  idx = 0
  enumerable.each do |element|
    yield element, idx
    idx += 1
  end
end

class ExerciseTest < MiniTest::Test
  def setup
    @arr = [1, 3, 6]
  end

  def test_output
    expected = <<~OUTPUT
      0 -> 1
      1 -> 3
      2 -> 36
    OUTPUT

    assert_output(expected) do
      each_with_index(@arr) { |value, index| puts "#{index} -> #{value**index}" }
    end
  end

  def test_return_value
    arr_dup = @arr.dup
    return_value = each_with_index(@arr) { 5 }
    assert_same(@arr, return_value)
    assert_equal(arr_dup, return_value)
  end
end
