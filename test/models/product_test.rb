require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    product = products(:chef_knife)
    assert product.valid?
  end

  test "requires a name" do
    product = products(:chef_knife)
    product.name = nil
    assert_not product.valid?
  end

  test "price must be non-negative" do
    product = products(:chef_knife)
    product.price = -5
    assert_not product.valid?
  end

  test "belongs to a category" do
    assert_equal "Knives", products(:chef_knife).category.name
  end

  test "in_stock scope excludes zero stock" do
    assert_includes Product.in_stock, products(:chef_knife)
    assert_not_includes Product.in_stock, products(:sold_out_cleaver)
  end

  test "search matches by name case-insensitively" do
    assert_includes Product.search("knife"), products(:chef_knife)
    assert_not_includes Product.search("axe"), products(:chef_knife)
  end

  test "by_category filters" do
    knives = Product.by_category(categories(:knives).id)
    assert_includes knives, products(:chef_knife)
    assert_not_includes knives, products(:hand_axe)
  end

  test "price range scopes" do
    assert_includes Product.min_price(150), products(:chef_knife)
    assert_not_includes Product.max_price(150), products(:chef_knife)
  end
end