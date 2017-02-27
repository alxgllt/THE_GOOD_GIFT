class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :update, :admin, :confirmation ]

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
    @order.save
    redirect_to order_path(@order)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.email = params[:email]
    @order.update(order_params)
    redirect_to order_path(@order)
  end

  def confirmation
    @order = Order.where(status: 'paid').find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:email)
  end
end
