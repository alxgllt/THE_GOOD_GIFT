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

    @matching_list = algo_matching(@products, params[:search_price].to_i)

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

  def algo_matching(products, price)
    product_list = list_format(products)
    available_cash = calc_available_cash(price)
    default_bundle_config = default_bundle_configuration(available_cash)
    matching_list = price_matching(available_cash, default_bundle_config, product_list)
    sorting_matching_list(matching_list)
  end

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
        big_proportion: 0,
        medium_proportion: 0,
        small_proportion: 0
      }
    }
    if available_cash >= 85 && available_cash < 150
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
    elsif available_cash <= 250 && available_cash < 325
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.6
      default_bundle_config[:proportion][:medium_proportion] = 0.275
      default_bundle_config[:proportion][:small_proportion] = 0.125
    elsif available_cash <= 325 && available_cash < 400
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.5
      default_bundle_config[:proportion][:medium_proportion] = 0.375
      default_bundle_config[:proportion][:small_proportion] = 0.125
    elsif available_cash <= 400 && available_cash < 500
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 2
      default_bundle_config[:proportion][:big_proportion] = 0.5
      default_bundle_config[:proportion][:medium_proportion] = 0.3
      default_bundle_config[:proportion][:small_proportion] = 0.1
    elsif available_cash <= 500 && available_cash < 600
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.667
      default_bundle_config[:proportion][:medium_proportion] = 0.25
      default_bundle_config[:proportion][:small_proportion] = 0.083
    else
      default_bundle_config[:big] = 2
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.345
      default_bundle_config[:proportion][:medium_proportion] = 0.25
      default_bundle_config[:proportion][:small_proportion] = 0.06
    end
    default_bundle_config
  end

  def price_matching(available_cash, default_bundle_config, product_list)
    matching_list = {
      big: [],
      medium: [],
      small: []
    }
    # si pas de big dans config, on supprime tout:
    unless default_bundle_config[:big] == 0
      # on itère sur les big
      product_list[:big].each do |product|
        if product.price <= available_cash * default_bundle_config[:proportion][:big_proportion] &&
            product.price >= available_cash * default_bundle_config[:proportion][:big_proportion] * 0.85
          matching_list[:big] << product
        end
      end
    end
    # si pas de medium dans config, on supprime tout:
    unless default_bundle_config[:medium] == 0
      # on itère sur les medium
      product_list[:medium].each do |product|
        if product.price <= available_cash * default_bundle_config[:proportion][:medium_proportion] &&
            product.price >= available_cash * default_bundle_config[:proportion][:medium_proportion] * 0.85
          matching_list[:medium] << product
        end
      end
    end
    # si pas de small dans config, on supprime tout:
    unless default_bundle_config[:small] == 0
      # on itère sur les small
      product_list[:small].each do |product|
        if product.price <= available_cash * default_bundle_config[:proportion][:small_proportion] &&
            product.price >= available_cash * default_bundle_config[:proportion][:small_proportion] * 0.75
          matching_list[:small] << product
        end
      end
    end
    return matching_list
  end

  def sorting_matching_list(matching_list)
    matching_list[:big].sort_by! { |product| product[:sell_priority] }
    matching_list[:medium].sort_by! { |product| product[:sell_priority] }
    matching_list[:small].sort_by! { |product| product[:sell_priority] }
    matching_list
  end

end
