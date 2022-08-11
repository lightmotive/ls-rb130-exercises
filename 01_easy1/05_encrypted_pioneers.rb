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
      each_char.map { |char| translate_rot13_char(char) }.join
    end

    private

    def translate_rot13_char(char)
      char.tr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
              'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm')
    end
  end
end

# Use the Decryption module to patch `String` only through the end of this file.
using Decryption

inputs = ['Nqn Ybirynpr', 'Tenpr Ubccre', 'Nqryr Tbyqfgvar', 'Nyna Ghevat',
          'Puneyrf Onoontr', 'Noqhyynu Zhunzznq ova Zhfn ny-Xujnevmzv',
          'Wbua Ngnanfbss', 'Ybvf Unvog', 'Pynhqr Funaaba', 'Fgrir Wbof',
          'Ovyy Tngrf', 'Gvz Orearef-Yrr', 'Fgrir Jbmavnx', 'Xbaenq Mhfr',
          'Fve Nagbal Ubner', 'Zneiva Zvafxl', 'Lhxvuveb Zngfhzbgb',
          'Unllvz Fybavzfxv', 'Tregehqr Oynapu']

p inputs.map(&:decrypt_rot13)
