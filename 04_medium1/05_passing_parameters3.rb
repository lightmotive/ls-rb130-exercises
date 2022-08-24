# frozen_string_literal: true

items = %w[apples corn cabbage wheat]

def gather(items)
  puts "Let's start gathering food."
  yield(items)
  puts "We've finished gathering!"
end

gather(items) do |*first3, fourth|
  puts first3.join(', ')
  puts fourth
end

gather(items) do |first, *middle, last|
  puts first
  puts middle.join(', ')
  puts last
end

gather(items) do |first, *remaining|
  puts first
  puts remaining.join(', ')
end

gather(items) do |first, second, third, fourth|
  puts "#{first}, #{second}, #{third}, and #{fourth}"
end
