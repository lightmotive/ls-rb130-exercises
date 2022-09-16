# frozen_string_literal: true

require 'date'

# * Understand *
# - Input:
#   - Meetup.new(year_number, month_number)
#   - Meetup#day(weekday_name, wdomo_name)
#     - weekday_name options (case-insensitive):
#       %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
#     - wdomo_name options (case-insensitive):
#       %w[first second third fourth fifth last teenth]
# - Output:
#   - `nil` if there are no matching days
#   - Otherwise, first matching date as Date.new(year, month, month_day)
#
# * Ex/test *
# - Reviewed to identify additional rules, including output format.
#
# * Data structure *
# - Use hash maps for input conversion.

# * Algorithm *
# - First, narrow down the date range based on the provided occurrence.
#   - The first occurrence of any given is_weekday will fall between the 1st and
#     6 days after that. The second occurrence will fall between the 8th and
#     6 days after that; and so on.
#       - The 'teenth' group is 13th - 19th.
#   - To determine the last day, which is only applicable when we get beyond
#     the 4th occurrence group (29+ days, due to February having either
#     28 or 29 days), we choose the smaller of 2 days: the last day of the
#     group or the last day of the month.
# - Once we have a narrowed date range for the correct occurrence, find the
#   first date that matches the specified day.
#   - Get better performance by determining a day range, then constructing and
#     testing date objects until one is found.

# "WDOMO": Weekday of the Month Occurrence
class Meetup
  IS_WEEKDAY_SYM = {
    'sunday' => :sunday?, 'monday' => :monday?, 'tuesday' => :tuesday?,
    'wednesday' => :wednesday?, 'thursday' => :thursday?, 'friday' => :friday?,
    'saturday' => :saturday?
  }.freeze

  FIRST_DAY = {
    'first' => 1, 'second' => 8, 'third' => 15, 'fourth' => 22,
    'fifth' => 29, 'teenth' => 13, 'last' => nil
  }.freeze

  def initialize(year, month)
    @year = year
    @month = month
    @last_day = Date.new(@year, @month, -1).day
  end

  def day(weekday_name, wdomo_name)
    is_weekday_sym = IS_WEEKDAY_SYM[weekday_name.downcase]
    day_range = day_range(wdomo_name.downcase)
    day_range.find do |day|
      date = Date.new(@year, @month, day)
      break date if date.send(is_weekday_sym)
    end
  end

  def day_range(wdomo_name)
    first_day = FIRST_DAY[wdomo_name] || (@last_day - 6)
    last_day = [@last_day, first_day + 6].min
    first_day..last_day
  end
end
