# frozen_string_literal: true

require 'minitest/autorun'

class Test01 < MiniTest::Test
  def setup
    @value = 3
  end

  def test_value_odd_not_true
    assert_equal(true, @value.odd?)
  end
end
