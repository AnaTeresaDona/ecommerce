class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_order, only:[:pay_with_paypal]

  def update
    product = params[:cart][:product_id]
    quantity = params[:cart][:quantity]

    current_order.add_product(product, quantity)

    redirect_to root_url, notice: "Product added successfuly"
  end

  def show
    @order = current_order
  end

  def pay_with_paypal


    response = EXPRESS_GATEWAY.setup_purchase(@order.total_cents,
      ip: request.remote_ip,
      return_url: process_paypal_payment_cart_url,
      cancel_return_url: root_url,
      allow_guest_checkout: true,
      currency: "USD"
    )

    @order.create_payment("PEC", response.token)


    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end


#refactorizado, el método haga solo lo que dice su nombre, deja de calcular centavos.
  def process_paypal_payment
    #como creamos el método express_purchase_options, hay que agregarle la @details, para poder usarla fuera del método. 
    @details = EXPRESS_GATEWAY.details_for(params[:token])    

    response = EXPRESS_GATEWAY.purchase(proccessed_price, express_purchase_options)
    if response.success?
      payment = Payment.find_by(token: response.token)
      payment.close!

    end
  end

  def get_order
    @order = Order.find(params[:cart][:order_id]) 
  end


  def express_purchase_options 
    {
      ip: request.remote_ip,
      token: params[:token],
      payer_id: @details.payer_id,
      currency: "USD"
    }
  end

  def proccessed_price
    @details.params["order_total"].to_d * 100
  end
end
