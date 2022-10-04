# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'
require './robot_alt'

class RobotAltTest < Minitest::Test
  DIFFERENT_ROBOT_NAME_SEED = 1234
  SAME_INITIAL_ROBOT_NAME_SEED = 1000
  NAME_REGEXP = /\A[A-Z]{2}\d{3}\z/.freeze

  def test_has_name
    assert_match NAME_REGEXP, Robot.new.name
  end

  def test_name_sticks
    robot = Robot.new
    robot.name
    assert_equal robot.name, robot.name
  end

  def test_different_robots_have_different_names
    Kernel.srand DIFFERENT_ROBOT_NAME_SEED
    refute_equal Robot.new.name, Robot.new.name
  end

  def test_reset_name
    Kernel.srand DIFFERENT_ROBOT_NAME_SEED
    robot = Robot.new
    name = robot.name
    robot.reset
    name2 = robot.name
    refute_equal name, name2
    assert_match NAME_REGEXP, name2
  end

  def test_different_name_when_chosen_name_is_taken
    Kernel.srand SAME_INITIAL_ROBOT_NAME_SEED
    name1 = Robot.new.name
    Kernel.srand SAME_INITIAL_ROBOT_NAME_SEED
    name2 = Robot.new.name
    refute_equal name1, name2
  end

  def test_create_all_possible_robots
    Robot.initialize_factory!
    create_count = 676_000
    robots = []
    robots << Robot.new while robots.size < create_count
    assert_equal(create_count, robots.map(&:name).uniq.size)
    Robot.initialize_factory!
  end
end
