# frozen_string_literal: true

require 'date'

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
  WEEKDAY_NAMES = %w[sunday monday tuesday wednesday thursday friday saturday].freeze
  TEENTH_NAME = 'teenth'
  WEEKDAY_OCCURRENCE_NAMES = (%w[first second third fourth fifth last] << TEENTH_NAME).freeze

  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(weekday_name, weekday_occurrence_name)
    weekday_name = weekday_name.downcase
    weekday_occurrence_name = weekday_occurrence_name.downcase
    validate_day_input(weekday_name, weekday_occurrence_name)

    return teenths_date(weekday_name) if weekday_occurrence_name.downcase == TEENTH_NAME

    weekday_occurrence_date(weekday_name, weekday_occurrence_name)
  end

  private

  def validate_day_input(weekday_name, weekday_occurrence_name)
    unless WEEKDAY_NAMES.include?(weekday_name)
      raise ArgumentError, "Weekday should be one of #{WEEKDAY_NAMES.join(', ')} (case-insensitive)."
    end

    unless WEEKDAY_OCCURRENCE_NAMES.include?(weekday_occurrence_name)
      raise ArgumentError,
            "Weekday wday_occurrence should be one of #{WEEKDAY_OCCURRENCE_NAMES.join(', ')} (case-insensitive)."
    end
  end

  def month_date_range
    date_start = Date.new(year, month)
    date_start..(date_start.next_month.prev_day)
  end

  def teenths_date(weekday_name)
    dates = Date.new(year, month, 13)..Date.new(year, month, 19)
    dates.find do |date|
      date.wday == WEEKDAY_NAMES.index_of(weekday_name.downcase)
    end
  end

  def weekday_occurrence_date(weekday_name, weekday_occurrence_name)
    dates = month_date_range
    wday = WEEKDAY_NAMES.index_of(weekday_name)
    wday_occurrence = WEEKDAY_OCCURRENCE_NAMES.index_of(weekday_occurrence_name)
    dates_by_weekday = dates.group_by(&:wday)
    weekday_dates = dates_by_weekday[wday]
    weekday_dates[wday_occurrence]
  end
end
