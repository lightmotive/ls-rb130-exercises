require_relative 'diamond'

class DiamondAlt
  def self.make_diamond(letter)
    range = ('A'..letter).to_a + ('A'...letter).to_a.reverse
    diamond_width = max_width(letter)

    range.each_with_object([]) do |let, arr|
      arr << make_row(let).center(diamond_width)
    end.join("\n") + "\n"
  end

  class << self
    private

    def make_row(letter)
      return 'A' if letter == 'A'
      return 'B B' if letter == 'B'

      letter + determine_spaces(letter) + letter
    end

    def determine_spaces(letter)
      all_letters = ['B']
      spaces = 1

      until all_letters.include?(letter)
        current_letter = all_letters.last
        all_letters << current_letter.next
        spaces += 2
      end

      ' ' * spaces
    end

    def max_width(letter)
      return 1 if letter == 'A'

      determine_spaces(letter).count(' ') + 2
    end
  end
end

class DiamondAlt2
  def self.make_diamond(letter)
    ar = ('A'..letter).to_a
    l = ar.length
    first = ar.map.with_index do |el, ind|
      outer = space(l - (ind + 1))
      y = el == 'A' ? '' : el
      outer + el + space((ind * 2) - 1) + y + outer + "\n"
    end
    (first + first[0..-2].reverse).join
  end

  class << self
    private

    def space(num)
      num > 0 ? ' ' * num : ''
    end
  end
end

require_relative '../../../ruby-common/benchmark_report'

TESTS = [{ input: 'E', expected_output: Diamond.make_diamond('E') },
         { input: 'Z', expected_output: Diamond.make_diamond('Z') }].freeze

benchmark_report(5, 5, TESTS,
                 [{ label: 'DiamondIncrementSpace', method: ->(input) { Diamond.make_diamond(input) } },
                  { label: 'DiamondCalculateSpace', method: ->(input) { DiamondAlt.make_diamond(input) } },
                  { label: 'DiamondAlt2', method: ->(input) { DiamondAlt2.make_diamond(input) } }])

# My solution is at least 3x faster than Launch School's proposed solution
# when testing smaller data sets { A..E }. That performance gap increases with
# larger data sets, e.g., with { A..Z }, the incremental approach is around
# 10x faster.
# How would I describe that in Big O notation?

# Another student's solution is sometimes faster, sometimes slower...but is much
# harder to read and maintain.
