require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "index renders" do
    get root_path
    assert_response :success
  end

  test "index search filters results" do
    get root_path, params: { q: "knife" }
    assert_response :success
    assert_match "Knife", @response.body
    assert_no_match "Hand Axe", @response.body
  end

  test "show renders a product" do
    get product_path(products(:chef_knife))
    assert_response :success
    assert_match "Knife", @response.body
  end
end