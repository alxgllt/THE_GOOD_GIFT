class PaymentsController < ApplicationController
 skip_before_action :authenticate_user!, only: [ :show, :create ]

  def new
   @order = Order.where(status: 'pending').find(params[:order_id])

  end

  def create
    @order = Order.where(status: 'pending').find(params[:order_id])

    customer = Stripe::Customer.create(
    source: params[:stripeToken],
    email:  params[:stripeEmail]
  )

  charge = Stripe::Charge.create(
    customer:     customer.id,   # You should store this customer id and re-use it.
    amount:  @order.total_price_cents, # or amount_pennies
    description:  "Payment for order #{@order.id} for order #{@order.id}",
    currency:     @order.total_price.currency
  )

  @order.update(payment: charge.to_json, status: 'paid')
  redirect_to confirmation_order_path(@order)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_payment_path(@order)
end

private

  def set_order
    @order = Order.where(status: 'pending').find(params[:order_id])
  end

end
