# frozen_string_literal: true

def convert_to_base8(n)
  n.to_s(8).to_i
end

base8_method = method(:convert_to_base8)
p [8, 10, 12, 14, 16, 33].map(&base8_method) == [10, 12, 14, 16, 20, 41]
