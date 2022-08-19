# frozen_string_literal: true

def gather(items)
  puts "Let's start gathering food."
  yield(items)
  puts 'Nice selection of food we have gathered!'
end

items = %w[apples corn cabbage wheat]

gather(items) { puts "#{items.join(', ')}" }
