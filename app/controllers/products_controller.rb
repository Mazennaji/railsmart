class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @sort = params[:sort]

    scope = Product.includes(:category)
                   .search(params[:q])
                   .by_category(params[:category_id])
                   .min_price(params[:min_price])
                   .max_price(params[:max_price])
                   .sorted_by(@sort)

    @pagy, @products = pagy(scope)
  end

  def show
    @product = Product.find(params[:id])
  end
end