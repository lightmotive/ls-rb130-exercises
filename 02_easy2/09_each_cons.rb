# frozen_string_literal: true

def each_cons(enumerable, size)
  # A normal program wouldn't try to recreate this method for code maintenance
  # and performance reasons (memory and access/execution time).
  # To fulfill exercise requirements/restrictions and enable support for any
  # enumerable, convert to an array:
  entries = enumerable.to_a
  start_idx_range = (0..(entries.size - size))

  start_idx_range.each do |start_idx|
    yield(entries.slice(start_idx, size))
  end

  nil
end

hash = {}
result = each_cons([1, 3, 6, 10], 2) do |value1, value2|
  hash[value1] = value2
end
p result.nil?
p hash == { 1 => 3, 3 => 6, 6 => 10 }

hash = {}
result = each_cons([], 2) do |value1, value2|
  hash[value1] = value2
end
p hash == {}
p result.nil?

hash = {}
result = each_cons(%w[a b], 2) do |value1, value2|
  hash[value1] = value2
end
p hash == { 'a' => 'b' }
p result.nil?
