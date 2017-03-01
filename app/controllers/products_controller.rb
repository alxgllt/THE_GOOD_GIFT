class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :admin ]

  # def index
  #   tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/tags.yml"))
  #   @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag.symbolize_keys) }
  #   @products = Product.all
  #   # search-bar product
  #   if params[:tags] != nil
  #     @products = @products.where("tag_one IN (?) OR tag_two IN (?)", params[:tags], params[:tags])
  #   end

  #   if params[:search_gender] != nil
  #     @products = @products.where(gender: [(params[:search_gender] == "Homme" ? "M" : "F"), "U"])
  #   end

  #   # business intelligence
  #   @order = Order.new()

  #   respond_to do |format|
  #     format.html
  #     format.js
  #   end
  # end

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
end
