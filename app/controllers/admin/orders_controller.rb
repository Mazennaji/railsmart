class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update]

  def index
    @pagy, @orders = pagy(Order.order(created_at: :desc))
  end

  def show
  end

  def update
    if @order.update(status: params[:order][:status])
      redirect_to admin_order_path(@order), notice: "Order status updated."
    else
      redirect_to admin_order_path(@order), alert: "Couldn't update status."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end