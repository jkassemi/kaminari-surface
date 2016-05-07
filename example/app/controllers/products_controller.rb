class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).
      per(params[:per] || 25).surface(50)
  end
end
