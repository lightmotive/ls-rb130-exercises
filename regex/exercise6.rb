# frozen_string_literal: true

def format_date(string)
  string.gsub(/(\d{4})-(\d{2})-(\d{2})/, '\3.\2.\1') # \1: year; \2: month; \3: day
end

p format_date('2016-06-17') == '17.06.2016'
p format_date('2016/06/17') == '2016/06/17' # no change
