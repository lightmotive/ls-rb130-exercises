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

hash = {}
each_cons([1, 3, 6, 10], 1) do |(value)|
  hash[value] = true
end
p hash == { 1 => true, 3 => true, 6 => true, 10 => true }

hash = {}
each_cons([1, 3, 6, 10], 2) do |value1, value2|
  hash[value1] = value2
end
p hash == { 1 => 3, 3 => 6, 6 => 10 }

hash = {}
each_cons([1, 3, 6, 10], 3) do |value1, *values|
  hash[value1] = values
end
p hash == { 1 => [3, 6], 3 => [6, 10] }

hash = {}
each_cons([1, 3, 6, 10], 4) do |value1, *values|
  hash[value1] = values
end
p hash == { 1 => [3, 6, 10] }

hash = {}
each_cons([1, 3, 6, 10], 5) do |value1, *values|
  hash[value1] = values
end
p hash == {}
