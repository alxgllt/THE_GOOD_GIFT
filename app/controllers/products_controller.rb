class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :admin ]

  def index
    tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/tags.yml"))
    @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag.symbolize_keys) }
    @products = Product.all
    # search-bar product
    if params[:tags] != nil
      @products = @products.where("tag_one IN (?) OR tag_two IN (?)", params[:tags], params[:tags])
    end

    if params[:search_gender] != nil
      @products = @products.where(gender: [(params[:search_gender] == "Homme" ? "M" : "F"), "U"])
    end

    #affichage bundle
    @matching_list = algo_matching(@products, params[:search_price].to_i * 100)

    # business intelligence
    @order = Order.new()

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
      @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to root_path
  end

  def second_choice
    raise
    @main = Product.find(params[:main_gift_id])
    redirect_to gift_two_path
  end

  private

  def algo_matching(products, price)
    available_cash = calc_available_cash(price)
    default_bundle_config = default_bundle_configuration(available_cash)
    product_list = list_format(products, available_cash, default_bundle_config)
    sorting_matching_list(product_list)
  end

  def calc_available_cash(price)
    price * 0.99
  end

  def default_bundle_configuration(available_cash)
    default_bundle_config = {
      gifts_number: 3,
      min_proportion: 0.4,
      max_proportion: 0.7
    }
    if available_cash <= 20000
      default_bundle_config[:gifts_number] = 2
    end
    default_bundle_config
  end

  def list_format(products, available_cash, default_bundle_config)
    product_list = {
      main: [],
      side_one: [],
      side_two: []
    }
    products.each do |product|
      if product.price_cents >= default_bundle_config[:min_proportion] * available_cash &&
         product.price_cents <= default_bundle_config[:max_proportion] * available_cash
        product_list[:main] << product
      end
    end
    return product_list
  end

  def sorting_matching_list(product_list)
    product_list[:main].sort_by! { |product| product[:sell_priority] }
    product_list[:side_one].sort_by! { |product| product[:sell_priority] }
    product_list[:side_two].sort_by! { |product| product[:sell_priority] }
    product_list
  end

end
