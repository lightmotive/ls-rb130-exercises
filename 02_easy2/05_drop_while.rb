# frozen_string_literal: true

# Implementation for Array-like objects only
def drop_while(array)
  index = 0
  index += 1 while index < array.size && yield(array[index])

  array[index..]
end

# **Implementation for any Enumerable object:**
def drop_while_with_enum_support(enumerable)
  keep_searching = true
  enumerable.each_with_object([]) do |args, keep|
    next if keep_searching && yield(args)

    keep_searching = false
    keep << args
  end
end

require_relative '../../ruby-common/benchmark_report'
require_relative '../../ruby-common/test'

TESTS = [
  { label: 'odd?', input:  [[1, 3, 5, 6], proc { |value| value.odd? }], expected_output: [6] },
  { label: 'even?', input: [[1, 3, 5, 6], proc { |value| value.even? }], expected_output: [1, 3, 5, 6] },
  { label: 'true', input: [[1, 3, 5, 6], proc { true }], expected_output: [] },
  { label: 'false', input: [[1, 3, 5, 6], proc { false }], expected_output: [1, 3, 5, 6] },
  { label: 'value < 5', input: [[1, 3, 5, 6], proc { |value| value < 5 }], expected_output: [5, 6] },
  { label: 'large array, break early',
    input: [[1, 3, 5, 6] * 100, proc { |value| value < 5 }],
    expected_output: ([1, 3, 5, 6] * 100)[2..] },
  { label: 'large array, break late',
    input: [([1, 3, 5, 6] * 100).push(20, 21, 22), proc { |value| value < 20 }],
    expected_output: [20, 21, 22] },
  { label: '[], true', input: [[], proc { true }], expected_output: [] } # ,
  # { label: 'Hash', input: [{ a: 'A', b: 'B' }, proc { |k, _| k == :a }], expected_output: [[:b, 'B']] }
].freeze

run_tests('arrays_only', TESTS, ->(input) { drop_while(input[0], &input[1]) })
run_tests('enum_support', TESTS, ->(input) { drop_while_with_enum_support(input[0], &input[1]) })

benchmark_report(5, 500, TESTS,
                 [
                   { label: 'arrays_only', method: ->(input) { drop_while(input[0], &input[1]) } },
                   { label: 'enum_support', method: ->(input) { drop_while_with_enum_support(input[0], &input[1]) } }
                 ])

# The Array-only implementation is much faster with larger arrays, and not
# much slower with small arrays, so I would choose that.
