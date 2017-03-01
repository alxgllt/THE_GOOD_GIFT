class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :new, :admin ]
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

    # on trie les produits
    @products = Product.all
    if @cart.tags != nil
      @products = @products.where("tag_one IN (?) OR tag_two IN (?)", @cart.tags, @cart.tags)
    end
    if @cart.gender != nil
      @products = @products.where(gender: [(@cart.gender == "Homme" ? "M" : "F"), "U"])
    end

    #affichage bundle
    @matching_list = algo_matching(@products, @cart)
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
    @cart.gift_number = params[:gift_number]
    @cart.save
    redirect_to cart_path(@cart)
  end

  private

  def cart_params
    params.permit(:name, :price, :gender, :tags)
  end

  def algo_matching(products, cart)
    unless cart.gift_number == cart.cart_products.count
      products_updated = remove_cart_products(products, cart)
      available_cash = calc_available_cash(cart)
      default_bundle_config = default_bundle_configuration(available_cash, cart)
      product_list = list_format(products_updated, available_cash, default_bundle_config)
      sorting_matching_list(product_list)
    end
  end

  def remove_cart_products(products, cart)
    products.select { |product| !cart.include?(product) }
  end

  def calc_available_cash(cart)
    if cart.products.empty?
      cart.price * 100 * 0.99
    else
      cart.price * 100 - ( cart.products.inject(0) { |sum, product| sum + product.price_cents } )
    end
  end

  def default_bundle_configuration(available_cash, cart)
    default_bundle_config = {
      gift_number: cart.gift_number,
      min_proportion: 0.4,
      max_proportion: 0.7
    }
    if cart.products.count == cart.gift_number - 1
      default_bundle_config[:min_proportion] = 0.8
      default_bundle_config[:max_proportion] = 1
    end
    default_bundle_config
  end

  def list_format(products, available_cash, default_bundle_config)
    product_list = []
    products.each do |product|
      if product.price_cents >= default_bundle_config[:min_proportion] * available_cash &&
          product.price_cents <= default_bundle_config[:max_proportion] * available_cash
        product_list << product
      end
    end
    return product_list
  end

  def sorting_matching_list(product_list)
    product_list.sort_by! { |product| product[:sell_priority].to_i }
    product_list
  end
end
