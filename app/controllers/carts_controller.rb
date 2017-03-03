class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :new, :admin, :surprise_me, :reinitialize_cart ]
  respond_to :js, :json, :html

  def new
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.tags = params[:tags]
    params[:price].to_i > 200 ? @cart.gift_number = 3 : @cart.gift_number = 2
    if @cart.save
      redirect_to cart_path(@cart)
    else
      redirect_to select_tags_path
    end
  end


  def show
    @cart = Cart.find(params[:id])
    # on récupère les tags
    tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/tags.yml"))
    @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag.symbolize_keys) }

    # business intelligence
    @order = Order.new()

    @matching_list = GiftSelectionService.new(@cart).call
  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def update
    @cart = Cart.find(params[:id])
    @cart.cart_products.destroy_all
    @cart.tags = params[:tags]
    @cart.name = params[:name]
    @cart.price = params[:price]
    @cart.gender = params[:gender]
    if params[:gift_number].to_i > @cart.gift_number_range.last
      @cart.gift_number = @cart.gift_number_range.last
    else
      @cart.gift_number = params[:gift_number].to_i
    end
    @cart.save
    redirect_to cart_path(@cart)
  end

  def surprise_me
    cart = Cart.find(params[:cart_id])
    cart.cart_products.destroy_all
    products = products_filtered(cart)
    cart.gift_number.times do
      gift = algo_matching(products, cart).sample
      cart_product = CartProduct.new()
      cart_product.cart = cart
      cart_product.product = gift
      cart_product.save
    end
    redirect_to cart_path(cart)
  end

  def reinitialize_cart
    cart = Cart.find(params[:cart_id])
    cart.cart_products.destroy_all
    redirect_to cart_path(cart)
  end

  private

  def cart_params
    params.permit(:name, :price, :gender, :tags)
  end
end
