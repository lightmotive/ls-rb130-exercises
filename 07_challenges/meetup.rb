# frozen_string_literal: true

# * Understand *
# - Input:
#   - Meetup.new(year_number, month_number)
#   - Meetup#day(weekday, weekday_occurrence_in_month)
#     - weekday options (case-insensitive):
#       %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
#     - weekday_occurrence_in_month options (case-insensitive):
#       %w[first second third fourth fifth last, teenth]
# - Output:
#   - `nil` if there are no matching days
#   - Otherwise, first matching date as Date.new(year, month, month_day)
#
# * Ex/test *
# - Reviewed to identify additional rules, including output format.
#
# * Data structure *
# - Organize a date range into a structure we can filter by Year and
#   Month (Date Range), then:
#   - group by weekday (Hash), then:
#     - sort by month day, count (e.g., first Monday), and retrieve the date
#       at a specific count (Array).
#
# * Algorithm *
=begin

=end
