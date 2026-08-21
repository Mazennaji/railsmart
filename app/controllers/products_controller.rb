class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @sort = params[:sort]

    @products = Product.includes(:category)
                       .search(params[:q])
                       .by_category(params[:category_id])
                       .min_price(params[:min_price])
                       .max_price(params[:max_price])
                       .sorted_by(@sort)
  end

  def show
    @product = Product.find(params[:id])
  end
end