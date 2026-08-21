require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "shows the cart" do
    get cart_path
    assert_response :success
  end

  test "adds a product to the cart" do
    post add_item_cart_path(products(:chef_knife)), params: { quantity: 2 }
    assert_redirected_to cart_path
    follow_redirect!
    assert_match "Chef's Knife", @response.body
  end

  test "removes a product from the cart" do
    post add_item_cart_path(products(:chef_knife))
    delete remove_item_cart_path(products(:chef_knife))
    assert_redirected_to cart_path
  end
end