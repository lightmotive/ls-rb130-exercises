# frozen_string_literal: true

class Tree
  include Enumerable

  # Methods required for Enumerable inclusion:
  def each(&block)
    # ...

    # internal_collection.each(&block)

    # self
  end

  # Items to be compared must implement #<=> to enable `sort` and related
  # methods.
end
