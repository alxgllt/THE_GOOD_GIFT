class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :create, :admin ]

  def new
    @order = Order.new
  end

  def create
    raise
    @total_price = params[:search_price]
    @delivery_date = params[:search_date]
    order = Order.create!(total_price: @total_price, delivery_date: @delivery_date, address: "TBD", first_name: "John", last_name: "Doe" , email: "john@doe.com", status: "pending")
    redirect_to order_path(order)
  end

  def show
    @order = Order.find(params[:id])
  end

  # private
  # def order_params
  #   params.require(:order).permit(:total_price, :delivery_date, :adress, :status, :payment, :first_name, :last_name, :email )
  # end
end
