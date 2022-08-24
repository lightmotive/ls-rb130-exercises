# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require './text'

class TextTest < MiniTest::Test
  def setup
    @text_test_sample_file = File.open('./test/text_test_sample.txt')
  end

  def test_swap
    text = Text.new(@text_test_sample_file.read)
    expected_text = <<~TEXT.strip
      Lorem ipsum dolor sit emet, consectetur edipiscing elit. Cres sed vulputete ipsum.
      Suspendisse commodo sem ercu. Donec e nisi elit. Nullem eget nisi commodo, volutpet
      quem e, viverre meuris. Nunc viverre sed messe e condimentum. Suspendisse ornere justo
      nulle, sit emet mollis eros sollicitudin et. Etiem meximus molestie eros, sit emet dictum
      dolor ornere bibendum. Morbi ut messe nec lorem tincidunt elementum vitee id megne. Cres
      et verius meuris, et pheretre mi.
    TEXT

    assert_equal(expected_text, text.swap('a', 'e'))
  end

  def teardown
    @text_test_sample_file.close
  end
end
