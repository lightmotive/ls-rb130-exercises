# frozen_string_literal: true

# ** Benchmark setup **
class RobotBenchmark
  def initialize(require_relative_name, create_count: 676_000, reset_count: 100)
    @require_relative_name = require_relative_name
    @create_count = create_count
    @reset_count = reset_count
    @robot_class = nil # Required on `run`
    @robots = []
  end

  def run
    puts "** #{require_relative_name} Benchmark **"

    bm_implementation
    bm_create
    bm_reset
  end

  private

  attr_reader :require_relative_name, :create_count, :reset_count,
              :robot_class, :robots

  def bm_implementation
    start_time = Time.now
    require_relative require_relative_name
    @robot_class = Robot
    puts "Init: #{seconds_round_fmt(Time.now - start_time, 3)} seconds"
  end

  def bm_create
    start_time = Time.now
    puts "Generating #{create_count} robots..."
    create_robots!
    format_bm('Generated', robots.size, Time.now - start_time)
  end

  def create_robots!
    case require_relative_name
    when 'robot_scalable' then create_robots_with_batch_init
    else
      create_robots_directly
    end
  end

  def create_robots_directly
    robots << robot_class.new while robots.size < create_count
  end

  def create_robots_with_batch_init
    robot_class.batch_init do
      robots.push(robot_class.new) while robots.size < create_count
    end
  end

  def bm_reset
    robots.shuffle!
    start_time = Time.now
    puts "Resetting #{reset_count} robots..."
    reset_count.times { robots.shift.reset }
    format_bm('Reset', reset_count, Time.now - start_time)
  end

  def format_bm(title, count, seconds)
    puts "#{title} #{count} robots in " \
         "~#{seconds_round_fmt(seconds, 2)} seconds " \
         "(~#{count.fdiv(seconds).floor}/sec)"
  end

  def seconds_round_fmt(seconds, decimal_places)
    format("%<sec>.#{decimal_places}f", sec: seconds)
  end
end

RobotBenchmark.new('robot', reset_count: 10).run
puts "\n"
RobotBenchmark.new('robot_alt', reset_count: 200).run
puts "\n"
RobotBenchmark.new('robot_scalable', reset_count: 20_000).run

# ***
# robot.rb performance analysis
# ***
# Init: 0.005 seconds
# Generated 676000 robots in ~50.71 seconds (~13330/sec)
# Reset 10 robots in ~21.74 seconds (~0/sec)
#
# Analysis:
# - Reasonably fast implementation that slows to a crawl when all names are used
#   because it takes time to randomly generate and check what hasn't already
#   been used.
# - Performance will be inconsistent because of that random nature and the
#   binary search algorithm.
# - Reset time is very slow (less than 0.5 robots/sec) due to the slow creation
#   time when there are many robots in use. This would be much faster with
#   fewer active robots.
# - Because startup time is not impacted, this would be a good solution for
#   small-scale scenarios.

# ***
# robot_alt.rb performance analysis
# ***
# Init: 0.658 seconds
# Generated 676000 robots in ~0.33 seconds (~2057247/sec)
# Reset 200 robots in ~7.35 seconds (~27/sec)
#
# Analysis:
# - Init is slightly slower because it generates and shuffles all possible
#   names.
# - The startup performance penalty then yields vastly improved creation time
#   and consistent performance regardless of the number of active robots.
# - Reset time is improved thanks to faster creation time, but still somewhat
#   slow because it uses **Array#delete* instead of a binary search
#   implementation. ./robot_scalable.rb solves that.
#
# Trade-offs due to generating and randomizing all possible names at program
# start:
# - Slightly slower startup time; probably not a problem in a scenario where a
#   class/factory is initialized only occasionally.
# - Higher initial memory usage; we're not storing a lot of data, so it wouldn't
#   be an issue in most cases.

# ***
# robot_scalable.rb performance analysis
# ***
# Init: 0.709 seconds
# Generated 676000 robots in ~0.41 seconds (~1638265/sec)
# Reset 20000 robots in ~2.56 seconds (~7816/sec)
#
# Analysis:
# - Compared to ./robot_alt.rb, this implementation requires slightly more time
#   (~0.25 seconds) to batch-generate all robots because it sorts used names
#   once at the end of the batch.
# - Now that we're using a fast name distribution algorithm and binary search
#   for tracking used names, both batch initialization and batch resetting
#   are fast.

# Choosing the best implementation would require knowing how many robots would
# be online at once, and how quickly those robots would need to be brought
# online.
