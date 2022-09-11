# frozen_string_literal: true

def fields(string)
  # whitespace or comma
  string.split(/[ \t,]+/)
end

p fields('Pete,201,Student') == %w[Pete 201 Student]

p fields("Pete \t 201    ,  TA") == %w[Pete 201 TA]

p fields("Pete \t 201") == %w[Pete 201]

p fields("Pete \n 201") == %W[Pete \n 201]
