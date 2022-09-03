# frozen_string_literal: true

class Series
  attr_reader :integers

  def initialize(integers)
    @integers = integers
  end

  def slices(length)
    raise ArgumentError, 'Slice length must be <= integer string length.' if length > integers.length

    # Algorithm...
  end
end
