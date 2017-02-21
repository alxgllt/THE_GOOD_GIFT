class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :admin ]

  def new
    @order = Order.new
  end
  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit(:total_price, :delivery_date, :adress, :status, :payment, :first_name, :last_name, :email )
  end
end
