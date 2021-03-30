require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "Payment is marqued as completed" do
    user_one = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user:user_one, total: 100)

    pm = PaymentMethod.create(name:"Paypal Express Checkout" , code: "PEC")
    payment = Payment.create(order_id: order.id, payment_method_id: pm.id, state:"processing", total: 100, token: "token_12345678")

    payment.complete!
    
    assert_equal payment.state, "completed"
    
  end

  test "complete and close payment" do
    user_one = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user:user_one, total: 100)

    pm = PaymentMethod.create(name:"Paypal Express Checkout" , code: "PEC")
    payment = Payment.create(order_id: order.id, payment_method_id: pm.id, state:"processing", total: 100, token: "token_12345678")

    payment.close! 

    assert_equal payment.state, "completed"
    assert_equal payment.order.state, "completed"
  end
end
