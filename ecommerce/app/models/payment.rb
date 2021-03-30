class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_method

  def close!
    ActiveRecord::Base.transaction do
    #obliga a que todo lo que está dentro del ActiveRecord deba funcionar. Si uno falla, no funciona ninguno. No debe estar en el controlador. 
    order.complete!
    complete!
    end
  end

  def complete!
    update_attributes({state: "completed"})
  end
end



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
