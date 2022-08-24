require 'minitest/autorun'
require './transaction'

class TransactionTest < MiniTest::Test
  def setup
    @item_cost = 30
    @transaction = Transaction.new(@item_cost)
    @you_owe_stdout = "You owe $#{@item_cost}.\nHow much are you paying?\n"
    @invalid_amount_stdout = 'That is not the correct amount. ' \
    "Please make sure to pay the full cost.\n"
  end

  def test_prompt_for_payment_exact
    input = StringIO.new("#{@item_cost}\n")
    output = StringIO.new

    @transaction.prompt_for_payment(input: input, output: output)
    assert_equal(@item_cost, @transaction.amount_paid)
    output.rewind
    assert_equal(@you_owe_stdout, output.read)
  end

  def test_prompt_for_payment_invalid
    input = StringIO.new("-10\n20\n30\n")
    output = StringIO.new

    incorrect_amount_stdout_sequence = "#{@invalid_amount_stdout}#{@you_owe_stdout}"
    expected_stdout = <<~STDOUT.chomp
      #{@you_owe_stdout.chomp}
      #{incorrect_amount_stdout_sequence * 2}
    STDOUT

    @transaction.prompt_for_payment(input: input, output: output)
    assert_equal(@item_cost, @transaction.amount_paid)
    output.rewind
    assert_equal(expected_stdout, output.read)
  end

  def test_prompt_for_payment_over
    input = StringIO.new("40\n")
    @transaction.prompt_for_payment(input: input, output: StringIO.new)
    assert_equal(40, @transaction.amount_paid)
  end
end
