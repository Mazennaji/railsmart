class Admin::DashboardController < Admin::BaseController
  def index
    @product_count  = Product.count
    @category_count = Category.count
    @order_count    = Order.count
    @revenue        = Order.sum(:total)
    @low_stock      = Product.where("stock <= ?", 5).order(:stock)
    @recent_orders  = Order.order(created_at: :desc).limit(5)
  end
end