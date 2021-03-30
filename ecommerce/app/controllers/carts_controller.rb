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
    #creo un método que me permita usar order = Order.find(params[:cart][:order_id])  en todas partes. Así no tengo que volver a crear la order cada vez que la ocupe en el controlador. Con el @order optimizado en toda la clase queda una sola orden, ya no hay dos distintas. 
    #order = Order.find(params[:cart][:order_id]) 

    #price must be in cents
    #price = @order.total * 100
    #la línea deja de ser necesaria, porque se tiene la order completa y se creó el método total_cents en el modelo (que aplica a toda la orden)
    #@order.total_cents

    response = EXPRESS_GATEWAY.setup_purchase(@order.total_cents,
      ip: request.remote_ip,
      return_url: process_paypal_payment_cart_url,
      cancel_return_url: root_url,
      allow_guest_checkout: true,
      currency: "USD"
    )

    @order.create_payment("PEC", response.token)

    # payment_method = PaymentMethod.find_by(code: "PEC")
    # Payment.create(
    #   order_id: @order.id,
    #   payment_method_id: payment_method.id,
    #   state: "processing",
    #   total: @order.total,
    #   token: response.token
    # )

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
      ##payment.close!: el estado de payment está completo, el estado de order está completo y ambas están cerradas. Hay que implementarlo en payment, porque es ahí donde ocurre. 
      # order = payment.order
      # #update object states
      # payment.state = "completed"
      # order.state = "completed"

      # ActiveRecord::Base.transaction do
      #   #obliga a que todo lo que está dentro del ActiveRecord deba funcionar. Si uno falla, no funciona ninguno. No debe estar en el controlador. 
      #   order.save!
      #   payment.save!
      # end
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
