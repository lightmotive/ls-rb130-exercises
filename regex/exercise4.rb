# frozen_string_literal: true

# frozen_string_literal: true

def mysterious_math(string)
  string.gsub(%r{[+*/-]}, '?')
end

p mysterious_math('4 + 3 - 5 = 2') == '4 ? 3 ? 5 = 2'
p mysterious_math('(4 * 3 + 2) / 7 - 1 = 1') == '(4 ? 3 ? 2) ? 7 ? 1 = 1'
