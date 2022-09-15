# frozen_string_literal: true

# * Understand *
# - Input:
#   - Meetup.new(year_number, month_number)
#   - Meetup#day(weekday_name, weekday_occurrence_name)
#     - weekday_name options (case-insensitive):
#       %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
#     - weekday_occurrence_name options (case-insensitive):
#       %w[first second third fourth fifth last teenth]
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
#   - group by weekday_name (Hash), then:
#     - sort by month day, count (e.g., first Monday), and retrieve the date
#       at a specific count (Array).

class Meetup
  WEEKDAY_NAMES = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
  WEEKDAY_OCCURRENCE_NAMES = %w[first second third fourth fifth last teenth].freeze

  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(weekday_name, weekday_occurrence_name)
    # - Rules:
    #   - Name inputs should be insensitive to case.
    #   - Raise an exception if inputs don't match associated options
    #     (minor UX improvement).

    # * Data structure *
    # - Organize a date range into a structure we can filter by Year and
    #   Month (Date Range), then:
    #   - group by weekday_name (Hash), then:
    #     - sort by month day, count (e.g., first Monday), and retrieve the date
    #       at a specific count (Array).

    # * Algorithm *
    # - `#month_days`: return date range breakdown for given year and month
    #   as described in data structure section.
    #   - Filter that breakdown by provided `weekday_name`
    #     - Filter that selection by provided `weekday_occurrence_name`

    #   - Find up to 1 matching day:
    #     - Return `nil` if no matching day is found.
    #     - Otherwise, return first matching date as
    #       Date.new(year, month, month_day).
  end
end
