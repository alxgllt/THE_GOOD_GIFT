class CartProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :new, :admin ]
  respond_to :js, :json, :html

  def new
    @cart_product = CartProduct.new
    @cart = Cart.find(params[:id])
  end

  def create
    @cart_product = CartProduct.new()
    raise
    @cart_product = Product.find(params[:main_id])
    # @cart_product.product = Product.find
    @cart_product.save
    redirect_to cart_path(@cart)
  end
end
