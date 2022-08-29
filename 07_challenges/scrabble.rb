# frozen_string_literal: true

# `Scrabble.new` Input: String (word)
# `Scrabble#score` Output: Integer (score)

# Rules:
# - Ignore nil, empty string, and whitespace
# - Ignore case
# - Create class and instance methods with same name: `score`

# Data structure:
# - Store [letters_string, score] pairs in an array, then loop through array.

# Basic algorithm:
# Given a `word` (string):
# - Return 0 if `word` is `nil`
# - Upcase `word`
# - Use a series of `count` expressions to calculate score
#
# - To implement Scrabble::score, instantiate: `Score.new(word).score`.

class Scrabble
  attr_reader :word

  LETTER_SCORES = [
    ['AEIOULNRST', 1],
    ['DG', 2],
    ['BCMP', 3],
    ['FHVWY', 4],
    ['K', 5],
    ['JX', 8],
    ['QZ', 10]
  ].freeze

  def initialize(word)
    @word = word
  end

  def score
    return 0 if word.nil?

    word_up = word.upcase

    LETTER_SCORES.reduce(0) do |total_score, (letters, score_per_letter)|
      total_score + word_up.count(letters) * score_per_letter
    end
  end

  def self.score(word)
    Scrabble.new(word).score
  end
end
