require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "non-admin is turned away" do
    log_in_as users(:buyer)
    get admin_products_path
    assert_redirected_to root_path
  end

  test "guest is turned away" do
    get admin_products_path
    assert_redirected_to root_path
  end

  test "admin can list products" do
    log_in_as users(:boss)
    get admin_products_path
    assert_response :success
  end

  test "admin can create a product" do
    log_in_as users(:boss)
    assert_difference -> { Product.count }, 1 do
      post admin_products_path, params: {
        product: { name: "Nail Set", description: "Forged nails.", price: 12.5, stock: 100, category_id: categories(:tools).id }
      }
    end
  end

  test "admin can delete a product" do
    log_in_as users(:boss)
    assert_difference -> { Product.count }, -1 do
      delete admin_product_path(products(:hand_axe))
    end
  end
end