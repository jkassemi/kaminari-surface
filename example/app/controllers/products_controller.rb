class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).
      per(params[:per] || 5)
  end
end
