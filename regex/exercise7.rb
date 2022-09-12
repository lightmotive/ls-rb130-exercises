# frozen_string_literal: true

def format_date(string)
  regex = %r{
    \A
      (?<year>\d{4})(?<delim>[/-])(?<month>\d{2})\k<delim>(?<day>\d{2})
    \z
    }x
  string.gsub(regex, '\k<day>.\k<month>.\k<year>')
end

p format_date('2016-06-17') == '17.06.2016'
p format_date('2017/05/03') == '03.05.2017'
p format_date('2015/01-31') == '2015/01-31' # (no change)
