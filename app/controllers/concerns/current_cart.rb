module CurrentCart
  extend ActiveSupport::Concern

  included do
    helper_method :cart_items, :cart_count, :cart_total
    before_action :set_cart_count
  end

  private

  def cart
    session[:cart] ||= {}
  end

  def cart_items
    @cart_items ||= cart.filter_map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      { product: product, quantity: quantity.to_i, subtotal: product.price * quantity.to_i }
    end
  end

  def cart_count
    cart.values.sum(&:to_i)
  end

  def cart_total
    cart_items.sum { |item| item[:subtotal] }
  end

  def set_cart_count
    @cart_count = cart_count
  end
end