class CartsController < ApplicationController
  def show
  end

  def add
    product = Product.find(params[:product_id])
    quantity = params.fetch(:quantity, 1).to_i.clamp(1, product.stock)

    cart[product.id.to_s] = (cart[product.id.to_s].to_i + quantity).clamp(1, product.stock)
    session[:cart] = cart

    redirect_to cart_path, notice: "#{product.name} added to your cart."
  end

  def update
    product = Product.find(params[:product_id])
    quantity = params.fetch(:quantity, 1).to_i

    if quantity <= 0
      cart.delete(product.id.to_s)
    else
      cart[product.id.to_s] = quantity.clamp(1, product.stock)
    end
    session[:cart] = cart

    redirect_to cart_path, notice: "Cart updated."
  end

  def remove
    product = Product.find(params[:product_id])
    cart.delete(product.id.to_s)
    session[:cart] = cart

    redirect_to cart_path, notice: "#{product.name} removed from your cart."
  end
end