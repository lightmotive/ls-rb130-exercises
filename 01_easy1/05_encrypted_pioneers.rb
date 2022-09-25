# frozen_string_literal: true

# Added to Ruby 2.0, **Refinements** offer a way to extend a class, module, or
# the top level in manner that lexically scopes the extension to everything
# after a `using [refinement]` statement.
# - If activated ("used") at the top level, the refinement will be active until
#   the end of the file.
# Learn more here: https://docs.ruby-lang.org/en/master/syntax/refinements_rdoc.html
# Carefully read the *Scope* section.
module Decryption
  refine String do
    def decrypt_rot13
      tr('A-Za-z', 'N-ZA-Mn-za-m')
    end
  end
end

class FileLineComparer
  include Enumerable

  attr_reader :path1_line, :path2_line

  def initialize(path1_line, path2_line)
    @path1_line = path1_line
    @path2_line = path2_line
  end

  def each
    return to_enum unless block_given?

    File.open(path1_line) do |path1_io|
      path1_enum = path1_io.each
      File.open(path2_line) do |path2_io|
        path2_enum = path2_io.each

        loop do
          yield(path1_enum.next.chomp, path2_enum.next.chomp)
        end
      end
    end
  end

  def all_first_transformed_match_second?
    each do |path1_line, path2_line|
      transformed = yield(path1_line)
      return false if transformed != path2_line
    end

    true
  end
end

# Use the Decryption module to patch `String` in a lexically scoped manner
# so patch is active only through the end of this file.
using Decryption

# Iterate through each file's lines
puts(FileLineComparer.new(
  '05_encrypted_pioneers_input.txt',
  '05_encrypted_pioneers_expected_output.txt'
).map do |path1_line, path2_line|
  decrypted = path1_line.decrypt_rot13
  "Expectation matches decrypted? #{decrypted == path2_line} | #{path1_line} -> #{path2_line}"
end)

# Even simpler if you just want to transform and verify equality:
puts FileLineComparer.new(
  '05_encrypted_pioneers_input.txt',
  '05_encrypted_pioneers_expected_output.txt'
).all_first_transformed_match_second?(&:decrypt_rot13)
