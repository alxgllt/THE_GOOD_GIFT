class CartProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :new, :admin, :destroy]
  respond_to :js, :json, :html

  def new
    @cart_product = CartProduct.new
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.find(params[:cart_id])
    @cart_product = CartProduct.new
    @cart_product.cart = @cart
    @cart_product.product = Product.find(params[:main_id])
    @cart_product.save

    @matching_list = GiftSelectionService.new(@cart).call

    respond_to do |format|
      format.html { redirect_to cart_path(@cart) }
      format.js
    end
  end

  def destroy
    @cart = Cart.find(params[:cart_id])
    @cart_product = CartProduct.where(product_id: product.id)
    @cart_product.destroy

    @matching_list = GiftSelectionService.new(@cart).call

    respond_to do |format|
      format.html { redirect_to cart_path(@cart) }
      format.js
    end
  end
end
