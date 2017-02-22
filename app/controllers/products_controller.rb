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

    # business intelligence
    @order = Order.new()
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

  private
  def list_format(products)
    product_list = {
      big: [],
      medium: [],
      small: []
    }
    products.each do |product|
      if product.price < 50
        product_list[:small] << product
      elsif product.price < 150
        product_list[:medium] << product
      else
        product_list[:big] << product
      end
    end
    return product_list
  end

  def calc_available_cash(price)
    price * 0.85
  end

  def default_bundle_configuration(available_cash)
    default_bundle_config = {
      big: 0,
      medium: 0,
      small: 0,
      proportion: {
        big_proportion: 0.5,
        medium_proportion: 0.3,
        small_proportion: 0.2
      }
    }
    if available_cash <= 100 && available_cash < 150
      default_bundle_config[:big] = 0
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0
      default_bundle_config[:proportion][:medium_proportion] = 2.fdiv(3)
      default_bundle_config[:proportion][:small_proportion] = 1.fdiv(3)
    elsif available_cash <= 150 && available_cash < 250
      default_bundle_config[:big] = 0
      default_bundle_config[:medium] = 2
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0
      default_bundle_config[:proportion][:medium_proportion] = 0.4
      default_bundle_config[:proportion][:small_proportion] = 0.2
    elsif available_cash <= 250 && available_cash < 400
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.5
      default_bundle_config[:proportion][:medium_proportion] = 0.3
      default_bundle_config[:proportion][:small_proportion] = 0.2
    elsif available_cash <= 400 && available_cash < 600
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.5
      default_bundle_config[:proportion][:medium_proportion] = 0.3
      default_bundle_config[:proportion][:small_proportion] = 0.2
     else
      default_bundle_config[:big] = 2
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.3
      default_bundle_config[:proportion][:medium_proportion] = 0.25
      default_bundle_config[:proportion][:small_proportion] = 0.15
    end
  end

  def price_matching(available_cash, default_bundle_config, product_list)
    matching_list = {
      big: [],
      medium: [],
      small: []
    }
    product_list
  end

end
