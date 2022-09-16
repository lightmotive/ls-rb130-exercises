require_relative 'meetup'

require 'date'

class MeetupLS
  SCHEDULE_START_DAY = {
    'first' => 1,
    'second' => 8,
    'third' => 15,
    'fourth' => 22,
    'fifth' => 29,
    'teenth' => 13,
    'last' => nil
  }.freeze

  def initialize(year, month)
    @year = year
    @month = month
    @days_in_month = Date.civil(@year, @month, -1).day
  end

  def day(weekday, schedule)
    weekday = weekday.downcase
    schedule = schedule.downcase

    first_possible_day = first_day_to_search(schedule)
    last_possible_day = [first_possible_day + 6, @days_in_month].min

    (first_possible_day..last_possible_day).detect do |day|
      date = Date.civil(@year, @month, day)
      break date if day_of_week_is?(date, weekday)
    end
  end

  private

  def first_day_to_search(schedule)
    SCHEDULE_START_DAY[schedule] || (@days_in_month - 6)
  end

  def day_of_week_is?(date, weekday) # rubocop:disable Metrics/CyclomaticComplexity
    case weekday
    when 'monday'    then date.monday?
    when 'tuesday'   then date.tuesday?
    when 'wednesday' then date.wednesday?
    when 'thursday'  then date.thursday?
    when 'friday'    then date.friday?
    when 'saturday'  then date.saturday?
    when 'sunday'    then date.sunday?
    end
  end
end

class MeetupStudent
  DAYS = { 'monday' => :monday?,
           'tuesday' => :tuesday?,
           'wednesday' => :wednesday?,
           'thursday' => :thursday?,
           'friday' => :friday?,
           'saturday' => :saturday?,
           'sunday' => :sunday? }

  FIRST_DAY = { 'first' => 1,
                'second' => 8,
                'third' => 15,
                'fourth' => 22,
                'fifth' => 29,
                'teenth' => 13,
                'last' => nil }

  def initialize(year, month)
    @year = year
    @month = month
    @last_day = Date.new(@year, @month, -1).day
  end

  def day(weekday, schedule)
    weekday = DAYS[weekday.downcase]
    schedule = get_schedule(schedule.downcase)
    schedule.detect do |day|
      possible = Date.new(@year, @month, day)
      break possible if possible.send(weekday)
    end
  end

  def get_schedule(schedule)
    first_day = FIRST_DAY[schedule] || (@last_day - 6)
    last_day = [@last_day, first_day + 6].min
    (first_day..last_day)
  end
end

require_relative '../../../ruby-common/benchmark_report'

TESTS = [{ input: [2013, 7, 'Thursday', 'first'], expected_output: Date.civil(2013, 7, 4) },
         { input: [2016, 3, 'Monday', 'last'], expected_output: Date.civil(2016, 3, 28) },
         { input: [2016, 2, 'Sunday', 'fifth'], expected_output: nil }].freeze

benchmark_report(TESTS,
                 [{ label: 'Meetup - LS',
                    method: ->(input) { MeetupLS.new(*input.first(2)).day(*input.last(2)) } },
                  { label: 'Meetup - my solution',
                    method: ->(input) { Meetup.new(*input.first(2)).day(*input.last(2)) } },
                  { label: 'Meetup - another student',
                    method: ->(input) { MeetupStudent.new(*input.first(2)).day(*input.last(2)) } }],
                 iterations: 1000)
