# frozen_string_literal: true

def url?(string)
  string.match?(%r{\Ahttps?://\S+\z})
end

puts url?('http://launchschool.com') == true
puts url?('https://example.com') == true
puts url?('https://example.com hello') == false
puts url?('   https://example.com') == false
