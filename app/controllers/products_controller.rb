class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :admin ]

  def index
    @products = Product.all
    # search-bar product
    if params[:search_gender] != nil
      @products = @products.where(gender: [params[:search_gender].chars.first.capitalize, "U"])
    else
      @products = Product.all
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

end
