# frozen_string_literal: true

# `Scrabble.new` Input: String (word)
# `Scrabble#score` Output: Integer (score)

# Rules:
# - Ignore nil, empty string, and whitespace
# - Ignore case
# - Create class and instance methods with same name: `score`

# Data structure:
# - None required other than class

# Basic algorithm:
# Given a `word` (string):
# - Return 0 if `word` is `nil`
# - Upcase `word`
# - Use a series of `count` expressions to calculate score
#
# - To implement Scrabble::score, instantiate: `Score.new(word).score`.

class Scrabble
  def initialize; end
end
