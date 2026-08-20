class OrdersController < ApplicationController
  before_action :require_login

  def new
    redirect_to cart_path, alert: "Your cart is empty." and return if cart_items.empty?
    @order = Order.new
  end

  def create
    redirect_to cart_path, alert: "Your cart is empty." and return if cart_items.empty?

    @order = current_user.orders.new(order_params)

    ActiveRecord::Base.transaction do
      @order.total = cart_total
      @order.save!

      cart_items.each do |item|
        product = item[:product]
        raise ActiveRecord::Rollback if item[:quantity] > product.stock

        @order.order_items.create!(
          product: product,
          quantity: item[:quantity],
          price: product.price
        )
        product.update!(stock: product.stock - item[:quantity])
      end
    end

    if @order.persisted?
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Order placed. Thank you!"
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :email, :address)
  end
end