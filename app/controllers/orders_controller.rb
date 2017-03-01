class OrdersController < ApplicationController

  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :admin, :confirmation, :select_gift_card ]
  respond_to :js, :json, :html

  def new
        @order = Order.find(params[:id])
  end

  def create
    @order = Order.create(status: "pending", total_price: params[:total_price])

    if params[:big] != nil
      order_item_big = OrderItem.new()
      order_item_big.product = Product.find(params[:big])
      order_item_big.price = Product.find(params[:big]).price
      order_item_big.order = @order
      order_item_big.save
    end

    if params[:medium] != nil
      order_item_medium = OrderItem.new()
      order_item_medium.product = Product.find(params[:medium])
      order_item_medium.price = Product.find(params[:medium]).price
      order_item_medium.order = @order
      order_item_medium.save
    end

    if params[:small] != nil
      order_item_small = OrderItem.new()
      order_item_small.product = Product.find(params[:small])
      order_item_small.price = Product.find(params[:small]).price
      order_item_small.order = @order
      order_item_small.save
    end

    @order.cost = @order.products.inject(0) { |sum, product| sum + product.price }
    if @order.save
      redirect_to order_path(@order)
    else
      redirect_to root_path
    end
  end

  def show
    @order = Order.find(params[:id])
    cards_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/cards.yml"))
    @cards_as_objects = cards_as_hashes.map { |card| Card.new(card.symbolize_keys) }
  end

  def select_gift_card
    @order = Order.find(params[:order_id])
    @order.card = params[:order][:card]
    @order.save
    respond_to do |format|
      format.html { redirect_to order_path(@order) }
      format.js
    end
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      @email_changed = order_params[:email]
      @phone_changed = order_params[:phone]
      @address_changed = order_params[:address]
      @first_name_changed = order_params[:first_name]
      @last_name_changed = order_params[:last_name]
      @company_changed = order_params[:company]
      respond_to do |format|
        format.html { redirect_to order_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render order_path }
        format.js
      end
    end

  end

  def confirmation
    @order = Order.where(status: 'paid').find(params[:id])
    @similar_products_tags = @order.products.map do |product|
          product.tag_one
        end
        @similar_products_tags.uniq.each do |tag|
        @products = Product.where(tag_one: "#{tag}")
        @final_prodcuts = @products - @order.products
      end
  end

  private

  def order_params
    params.require(:order).permit(:first_name, :last_name, :company, :email, :address, :phone)
  end

end
