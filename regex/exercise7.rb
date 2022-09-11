# frozen_string_literal: true

def format_date(string)
  regex = %r{
  \A
    (\d{4}) # \1: year
    ([/-])  # \2: delimiter
    (\d{2}) # \3: month
    \2      # delimiter
    (\d{2}) # \4: day
  \z
  }x

  string.gsub(regex, '\4.\3.\1')
end

p format_date('2016-06-17') == '17.06.2016'
p format_date('2017/05/03') == '03.05.2017'
p format_date('2015/01-31') == '2015/01-31' # (no change)
