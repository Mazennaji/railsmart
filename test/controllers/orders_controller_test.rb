require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "checkout requires login" do
    get new_order_path
    assert_redirected_to login_path
  end

  test "logged-in user can view checkout with items in cart" do
    log_in_as users(:buyer)
    post add_item_cart_path(products(:chef_knife))
    get new_order_path
    assert_response :success
  end

  test "placing an order creates it and decrements stock" do
    log_in_as users(:buyer)
    post add_item_cart_path(products(:chef_knife)), params: { quantity: 2 }

    assert_difference -> { Order.count }, 1 do
      post orders_path, params: { order: { customer_name: "Sam", email: "sam@example.com", address: "1 Lane" } }
    end

    assert_equal 6, products(:chef_knife).reload.stock
  end

  test "users cannot view another user's order" do
    log_in_as users(:buyer)
    other = orders(:buyer_order)
    other.update!(user: users(:boss))
    assert_raises(ActiveRecord::RecordNotFound) do
      get order_path(other)
    end
  end
end