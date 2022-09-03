# frozen_string_literal: true

class Series
  attr_reader :integers

  def initialize(integers)
    @integers = integers
  end

  def slices(length)
    raise ArgumentError, 'Slice length must be <= integer string length.' if length > integers.length

    # Algorithm:
    # - Iterate through the string slices of specified length, incrementing
    #   the starting position with each iteration. Iterate from
    #   0..(integers.length - length), taking length of chars from string.
    #   - Map chars to_i.
  end
end
