class OrdersController < ApplicationController
  before_action :require_login

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def new
    redirect_to cart_path, alert: "Your cart is empty." and return if cart_items.empty?
    @order = Order.new
  end

  def create
    redirect_to cart_path, alert: "Your cart is empty." and return if cart_items.empty?

    @order = current_user.orders.new(order_params)
    @order.total = cart_total
    @order.status = "pending"

    unless @order.save
      return render :new, status: :unprocessable_entity
    end

    cart_items.each do |item|
      @order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    session = Stripe::Checkout::Session.create(
      mode: "payment",
      customer_email: current_user.email,
      line_items: @order.order_items.map { |item|
        {
          quantity: item.quantity,
          price_data: {
            currency: "usd",
            unit_amount: (item.price * 100).to_i,
            product_data: { name: item.product.name }
          }
        }
      },
      success_url: success_order_url(@order),
      cancel_url: cart_url
    )

    @order.update!(stripe_session_id: session.id)
    redirect_to session.url, allow_other_host: true
  end

  def success
    @order = current_user.orders.find(params[:id])

    if @order.paid_at.present?
      return redirect_to order_path(@order)
    end

    stripe_session = Stripe::Checkout::Session.retrieve(@order.stripe_session_id)

    if stripe_session.payment_status == "paid"
      ActiveRecord::Base.transaction do
        @order.order_items.each do |item|
          product = item.product
          product.update!(stock: product.stock - item.quantity)
        end
        @order.update!(status: "paid", paid_at: Time.current)
      end
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Payment received. Thank you!"
    else
      redirect_to cart_path, alert: "Payment was not completed."
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :email, :address)
  end
end