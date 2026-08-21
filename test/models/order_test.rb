require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "valid order" do
    assert orders(:buyer_order).valid?
  end

  test "requires a customer name" do
    order = orders(:buyer_order)
    order.customer_name = nil
    assert_not order.valid?
  end

  test "rejects a bad email" do
    order = orders(:buyer_order)
    order.email = "not-an-email"
    assert_not order.valid?
  end

  test "only allows known statuses" do
    order = orders(:buyer_order)
    order.status = "teleported"
    assert_not order.valid?
  end

  test "defaults status to pending" do
    assert_equal "pending", Order.new.status
  end

  test "belongs to a user" do
    assert_equal "buyer@example.com", orders(:buyer_order).user.email
  end
end