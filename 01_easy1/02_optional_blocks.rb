# frozen_string_literal: true

def compute
  return yield if block_given?

  'Does not compute.'
end

# just practicing...
require 'minitest/autorun'

class ComputeTest < MiniTest::Test
  def test_compute_block_given
    assert_equal(8, compute { 5 + 3 })
    assert_equal('ab', compute { 'a' + 'b' })
  end

  def test_compute_no_block_given
    assert_equal('Does not compute.', compute)
  end
end
