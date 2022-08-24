# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require './text'

class TextTest < MiniTest::Test
  def setup
    @text_test_sample = File.read('./test/text_test_sample.txt')
    @text = Text.new(@text_test_sample)
  end

  def test_swap
    assert_equal(@text_test_sample.gsub('a', 'e'), @text.swap('a', 'e'))
  end

  def teardown
    # ...
  end
end
