# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require './transaction'
require './cash_register'

class CashRegisterTest < MiniTest::Test
  def setup
    @default_item_cost = 30
    @transaction = Transaction.new(@default_item_cost)
    @default_total_money = 1200
    @register = CashRegister.new(@default_total_money)
  end

  def test_initialize
    assert_equal(@default_total_money, @register.total_money)
    assert_equal(@default_item_cost, @transaction.item_cost)
  end

  def test_accept_money
    @transaction.amount_paid = @default_item_cost
    @register.accept_money(@transaction)
    assert_equal(@default_total_money + @transaction.amount_paid, @register.total_money)
  end

  def test_change_zero
    @transaction.amount_paid = @default_item_cost
    assert_equal(0, @register.change(@transaction))
  end

  def test_change_positive
    @transaction.amount_paid = @default_item_cost + 10
    assert_equal(10, @register.change(@transaction))
  end

  def test_give_receipt
    expected_stdout = "You've paid $#{@default_item_cost}.\n"
    assert_output(expected_stdout) do
      @register.give_receipt(@transaction)
    end
  end
end
