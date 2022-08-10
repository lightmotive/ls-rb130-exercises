# frozen_string_literal: true

# Algorithm (src: https://qr.ae/pv5PPv):
# - Given a positive integer `n`
# - Run a loop from 1 to sqrt(n)
#   - if n is divisible by i:
#     - Add i to result
#     - if i and n/i are unequal, add n/i to result
def divisors(integer)
  (1..Integer.sqrt(integer)).each_with_object([]) do |divisor, result|
    q, m = integer.divmod(divisor)
    if m.zero?
      result << divisor
      result << q if divisor != q
    end
  end
end

p divisors(1) == [1]
p divisors(7) == [1, 7]
p divisors(12).sort == [1, 2, 3, 4, 6, 12]
p divisors(98).sort == [1, 2, 7, 14, 49, 98]
p divisors(99_400_891).sort == [1, 9967, 9973, 99_400_891] # may take a minute
p divisors(999_962_000_357).sort == [1, 999_979, 999_983, 999_962_000_357]
