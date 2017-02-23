class OrderItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create, :admin ]

  def new
    @order_items = OrderItems.new
  end

  def create
    @order_items = OrderItems.new(product_id)
    # if @order_items.save
    #   redirect_to order_path(@order)
    # else
    #   render :new
    # end
  end
end
