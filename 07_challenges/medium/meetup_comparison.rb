require_relative 'meetup'

class MeetupDOWM
  DAYS = { 'monday' => :monday?, 'tuesday' => :tuesday?,
           'wednesday' => :wednesday?, 'thursday' => :thursday?,
           'friday' => :friday?, 'saturday' => :saturday?,
           'sunday' => :sunday? }.freeze

  FIRST_DAY = { 'first' => 1, 'second' => 8, 'third' => 15,
                'fourth' => 22, 'fifth' => 29, 'teenth' => 13,
                'last' => nil }.freeze

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

class MeetupDOWMMod
  FIRST_DAY = { 'first' => 1, 'second' => 8, 'third' => 15,
                'fourth' => 22, 'fifth' => 29, 'teenth' => 13,
                'last' => nil }.freeze

  def initialize(year, month)
    @year = year
    @month = month
    @last_day = Date.new(@year, @month, -1).day
  end

  def day(weekday, schedule)
    weekday = "#{weekday.downcase}?".to_sym
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

benchmark_report(5, 5, TESTS,
                 [{ label: 'Meetup - Group By', method: ->(input) { Meetup.new(*input.first(2)).day(*input.last(2)) } },
                  { label: 'Meetup - DOWM Subset',
                    method: ->(input) { MeetupDOWM.new(*input.first(2)).day(*input.last(2)) } },
                  { label: 'Meetup - DOWM Mod',
                    method: ->(input) { MeetupDOWMMod.new(*input.first(2)).day(*input.last(2)) } }])
