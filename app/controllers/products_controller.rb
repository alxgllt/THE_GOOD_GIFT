class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @products = Product.all
    # business intelligence
    @order = Order.new()
  end
end
