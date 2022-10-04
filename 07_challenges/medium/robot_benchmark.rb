# frozen_string_literal: true

# ** Benchmark setup **
class RobotBenchmark
  def initialize(load_path, create_count: 676_000, reset_count: 100,
                 create_robots_proc: nil)
    @load_path = load_path
    @create_count = create_count
    @reset_count = reset_count
    @create_robots_proc = create_robots_proc ||
                          proc { |create_robots| create_robots.call }
    @robots = []
  end

  def run
    puts "** #{load_path} Benchmark **"

    bm_implementation
    bm_create
    bm_reset
  end

  private

  attr_reader :load_path, :create_count, :reset_count,
              :create_robots_proc, :robots

  def bm_implementation
    start_time = Time.now
    load load_path
    puts "Init: #{seconds_round_fmt(Time.now - start_time, 3)} seconds"
  end

  def bm_create
    start_time = Time.now
    puts "Generating #{create_count} robots..."
    create_robots_proc.call(method(:create_robots!))
    format_result('Generated', robots.size, Time.now - start_time)
  end

  def create_robots!
    robots << Robot.new while robots.size < create_count
  end

  def bm_reset
    robots.shuffle!
    start_time = Time.now
    puts "Resetting #{reset_count} robots..."
    reset_count.times { robots.shift.reset }
    format_result('Reset', reset_count, Time.now - start_time)
  end

  def format_result(title, count, seconds)
    puts "#{title} #{count} robots in " \
         "~#{seconds_round_fmt(seconds, 2)} seconds " \
         "(~#{count.fdiv(seconds).floor}/sec)"
  end

  def seconds_round_fmt(seconds, decimal_places)
    format("%<sec>.#{decimal_places}f", sec: seconds)
  end
end

case ARGV[0]
when 'robot' then RobotBenchmark.new('./robot.rb', reset_count: 5).run
when 'robot_alt' then RobotBenchmark.new('./robot_alt.rb', reset_count: 100).run
when 'robot_scalable'
  RobotBenchmark.new('./robot_scalable.rb',
                     reset_count: 20_000,
                     create_robots_proc: proc do |create_robots|
                       Robot.batch_init do
                         create_robots.call
                       end
                     end).run
end

# ***
# robot.rb performance analysis
# - cmd: ruby robot_benchmark.rb robot
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
# - cmd: ruby robot_benchmark.rb robot_alt
# ***
# Init: 0.627 seconds
# Generated 676000 robots in ~0.23 seconds (~2994063/sec)
# Reset 100 robots in ~2.48 seconds (~40/sec)
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
# - cmd: ruby robot_benchmark.rb robot_scalable
# ***
# Init: 0.662 seconds
# Generated 676000 robots in ~0.44 seconds (~1520558/sec)
# Reset 20000 robots in ~2.63 seconds (~7592/sec)
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
