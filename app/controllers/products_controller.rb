class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category).order(:name)
  end

  def show
    @product = Product.find(params[:id])
  end
end