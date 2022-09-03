# frozen_string_literal: true

class Series
  attr_reader :integers

  def initialize(integers)
    @integers = integers
  end

  def slices(length)
    raise ArgumentError, 'Slice length must be <= integer string length.' if length > integers.length

    0.upto(integers.length - length).reduce([]) do |result, start|
      result << slice_integers(start, length)
    end
  end

  private

  def slice_integers(start, length)
    integers[start, length].chars.map(&:to_i)
  end
end
