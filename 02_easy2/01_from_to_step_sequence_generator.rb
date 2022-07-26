# frozen_string_literal: true

def step(start_num, end_num, step)
  return enum_for(:step, start_num, end_num, step) unless block_given?

  current_num = start_num

  while current_num <= end_num
    yield current_num

    current_num += step
  end

  start_num..end_num # Return a Range to align with Core behavior.
end

rng = step(1, 10, 3) { |value| puts "value = #{value}" }
p rng
p(step(1, 10, 3).map { |value| "value = #{value}" } ==
  ['value = 1', 'value = 4', 'value = 7', 'value = 10'])
