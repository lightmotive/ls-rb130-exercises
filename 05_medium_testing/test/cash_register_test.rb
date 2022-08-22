# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require './transaction'
require './cash_register'

class CashRegisterTest < MiniTest::Test
  def setup
    @default_item_cost = 1
    @transaction = Transaction.new(@default_item_cost)
    @transaction.amount_paid = @default_item_cost
    @default_total_money = 100
    @register = CashRegister.new(@default_total_money)
  end

  def test_initialize
    assert_equal(@default_total_money, @register.total_money)
    assert_equal(@default_item_cost, @transaction.amount_paid)
  end

  def test_accept_money
    @register.accept_money(@transaction)
    assert_equal(@default_total_money + @transaction.amount_paid, @register.total_money)
  end
end
