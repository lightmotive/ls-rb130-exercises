# frozen_string_literal: true

require_relative 'file_line_comparer'

class Rot13
  FROM_RANGE = 'N-ZA-Mn-za-m'
  TO_RANGE = 'A-Za-z'

  def self.encrypt(string)
    string.tr(FROM_RANGE, TO_RANGE)
  end

  def self.decrypt(string)
    string.tr(TO_RANGE, FROM_RANGE)
  end
end

# Decrypt
puts FileLineComparer.new(
  '05_encrypted_pioneers_input.txt',
  '05_encrypted_pioneers_expected_output.txt'
).all_first_transformed_match_second?(&Rot13.method(:decrypt))

# Encrypt
puts FileLineComparer.new(
  '05_encrypted_pioneers_expected_output.txt',
  '05_encrypted_pioneers_input.txt'
).all_first_transformed_match_second?(&Rot13.method(:encrypt))
