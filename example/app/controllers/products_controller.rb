class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(params[:per] || 25)
  end
end
