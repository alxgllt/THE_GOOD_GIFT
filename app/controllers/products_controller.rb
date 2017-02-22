class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :admin ]

  def index
    @products = Product.all
    #raise
    # search-bar product
    if params[:search_gender] != nil
      @products = @products.where(gender: [params[:search_gender].chars.first.capitalize, "U"])
    else
      @products = Product.all
    end
    # business intelligence
    raise
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
    if available_cash =< 100 && available_cash < 150
      default_bundle_config[:big] = 0
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0
      default_bundle_config[:proportion][:medium_proportion] = 2.fdiv(3)
      default_bundle_config[:proportion][:small_proportion] = 1.fdiv(3)
    elsif available_cash =< 150 && available_cash < 250
      default_bundle_config[:big] = 0
      default_bundle_config[:medium] = 2
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0
      default_bundle_config[:proportion][:medium_proportion] = 0.4
      default_bundle_config[:proportion][:small_proportion] = 0.2
    elsif available_cash =< 250 && available_cash < 400
      default_bundle_config[:big] = 1
      default_bundle_config[:medium] = 1
      default_bundle_config[:small] = 1
      default_bundle_config[:proportion][:big_proportion] = 0.5
      default_bundle_config[:proportion][:medium_proportion] = 0.3
      default_bundle_config[:proportion][:small_proportion] = 0.2
    elsif available_cash =< 400 && available_cash < 600
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
end
